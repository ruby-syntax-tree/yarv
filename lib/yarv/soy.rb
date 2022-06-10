# frozen_string_literal: true

module YARV
  # Constructs a sea-of-yarv graph, or SOY graph -- a sea-of-nodes graph, from
  # a CFG.
  class SOY
    attr_reader :dfg
    attr_reader :start
    attr_reader :nodes

    def initialize(dfg)
      if dfg.cfg.iseq.throw_handlers.any?
        raise "throw handlers not supported in SOY yet"
      end

      @dfg = dfg
      @nodes = []
      @id_counter = 999

      # Create local subgraphs for each basic block.
      local_graphs = {}
      dfg.cfg.blocks.each do |block|
        local_graphs[block.start] = create_local_graph(block)
      end
      @start = local_graphs[dfg.cfg.blocks.first.start].first

      # Connect global control flow - connect basic blocks.
      dfg.cfg.blocks.each do |predecessor|
        predecessor_last = local_graphs[predecessor.start].last
        predecessor.succs.each do |successor|
          connect predecessor_last,
                  local_graphs[successor.start].first,
                  :control
        end
      end

      # Connect global dataflow - connect basic block argument outputs to
      # inputs.
      dfg.cfg.blocks.each do |predecessor|
        predecessor_graph = local_graphs[predecessor.start]
        predecessor_graph.out.values.each_with_index do |arg_out, arg_n|
          predecessor.succs.each do |successor|
            successor_graph = local_graphs[successor.start]
            arg_in = successor_graph.in.values[arg_n]
            connect arg_out, arg_in, :data
          end
        end
      end

      # Run post-build clean up.
      post_build
    end

    # Create a sub-graph for a single basic block - block block argument inputs
    # and outputs will be left dangling, to be connected later.
    def create_local_graph(block)
      block_dataflow = dfg.block_flow[block.start]

      # A map of instructions to nodes.
      insn_node_map = {}

      # Create a node for each instruction in the block.
      block
        .start
        .upto(block.start + block.length - 1) do |insn_pc|
          insn = dfg.cfg.iseq.insns[insn_pc]
          node = InsnNode.new(insn, insn_pc)
          insn_node_map[insn_pc] = node
          nodes.push node
        end

      # The first and last node in the sub-graph, and the last fixed node.
      previous_fixed = nil
      first_fixed = nil
      last_fixed = nil

      # If there is more than predecessor, and we have basic block arguments
      # coming in, then we need a merge node for the phi nodes to attach to.
      if block.preds.size > 1 && !block_dataflow.in.empty?
        merge = MergeNode.new(self)
        nodes.push merge
        previous_fixed = merge
        first_fixed = merge
        last_fixed = merge
      end

      # Connect local control flow (only nodes with side effects.)
      block
        .start
        .upto(block.start + block.length - 1) do |insn_pc|
          insn = dfg.cfg.iseq.insns[insn_pc]
          if insn.side_effects?
            insn_node = insn_node_map[insn_pc]
            connect previous_fixed, insn_node, :control if previous_fixed
            previous_fixed = insn_node
            first_fixed ||= insn_node
            last_fixed = insn_node
          end
        end

      # A graph with only side-effect free instructions will currently have
      # no fixed nodes! In that case just use the first instruction's node
      # for both first and last. But it's a bug that it'll appear in the
      # control flow path!
      first = first_fixed || insn_node_map[block.start]
      last = last_fixed || insn_node_map[block.start]

      # Connect basic block arguments.
      inputs = {}
      outputs = {}
      block_dataflow.in.each do |arg|
        # Each basic block argument gets a phi node. Even if there's only one
        # predecessor! We'll tidy this up later.
        phi = PhiNode.new(self)
        connect phi, merge, :info if merge
        nodes.push phi
        inputs[arg] = phi
        block
          .start
          .upto(block.start + block.length - 1) do |consumer_pc|
            consumer_dataflow = dfg.insn_flow[consumer_pc]
            consumer_dataflow.in.each do |producer|
              connect phi, insn_node_map[consumer_pc], :data if producer == arg
            end
          end
        block_dataflow.out.each { |out| outputs[out] = phi if out == arg }
      end

      # Connect local dataflow.
      block
        .start
        .upto(block.start + block.length - 1) do |producer_pc|
          producer_dataflow = dfg.insn_flow[producer_pc]
          producer_dataflow.out.each do |consumer|
            if consumer.is_a?(Integer)
              connect insn_node_map[producer_pc], insn_node_map[consumer], :data
            else
              # This is an argument to the successor block - not to an
              # instruction here.
              outputs[consumer] = insn_node_map[producer_pc]
            end
          end
        end

      SubGraph.new(first, last, inputs, outputs)
    end

    # We don't always build things in an optimal way. Go back and fix up some
    # mess we left! Ideally we wouldn't create these problems in the first
    # place.
    def post_build
      nodes.dup.each do |node| # dup because we're mutating the list of nodes
        case node
        when PhiNode
          if node.in.size == 1
            # Remove phi nodes with a single input.
            remove node, connect_over: true
          elsif node.in.map(&:from).uniq.size == 1
            # Remove phi nodes where all inputs are the same.
            producer = node.in.first.from
            consumer = node.out.filter { |e| !e.to.is_a?(MergeNode) }.first.to
            connect producer, consumer, :data
            remove node
          end
        when InsnNode
          case node.insn
          when Jump
            # Remove jump nodes (they were left because we needed a fixed end
            # node for the block).
            remove node, connect_over: true
          end
        end
      end
    end

    # Counter for synthetic nodes.
    def id_counter
      @id_counter += 1
    end

    # Connect one node to another.
    def connect(from, to, *tags)
      raise if from == to
      edge = Edge.new(from, to, *tags)
      from.out.push edge
      to.in.push edge
    end

    # Remove a node from the graph, optionally connecting edges that went
    # through it.
    def remove(node, connect_over: false)
      if connect_over
        node.in.each do |producer_edge|
          node.out.each do |consumer_edge|
            connect producer_edge.from, consumer_edge.to, *producer_edge.tags
          end
        end
      end

      node.in.each do |producer_edge|
        producer_edge.from.out.delete_if { |e| e.to == node }
      end

      node.out.each do |consumer_edge|
        consumer_edge.to.in.delete_if { |e| e.from == node }
      end

      nodes.delete node
    end

    def mermaid(output = StringIO.new)
      output.puts "flowchart TD"

      nodes.each { |node| output.puts "  node_#{node.id}(#{node})" }

      link_counter = 0
      nodes.each do |producer|
        producer.out.each do |consumer_edge|
          if consumer_edge.tags.include?(:info)
            edge = "-.->"
          else
            edge = "-->"
          end
          if consumer_edge.tags.include?(:data)
            edge_style = "stroke:green;"
          elsif consumer_edge.tags.include?(:control)
            edge_style = "stroke:red;"
          end
          output.puts "  node_#{producer.id} #{edge} node_#{consumer_edge.to.id}"
          output.puts "  linkStyle #{link_counter} #{edge_style}" if edge_style
          link_counter += 1
        end
      end

      output.string
    end

    class Node
      attr_reader :in
      attr_reader :out
      attr_reader :tags

      def initialize(*tags)
        @in = []
        @out = []
        @tags = tags
      end
    end

    class InsnNode < Node
      attr_reader :insn
      attr_reader :insn_pc

      def initialize(insn, insn_pc, *tags)
        super(*tags)
        @insn = insn
        @insn_pc = insn_pc
      end

      def id
        insn_pc
      end

      def to_s
        "#{InstructionSequence.disasm_pc(insn_pc)} #{insn.class.name.split("::").last}"
      end
    end

    class SynthNode < Node
      attr_reader :id

      def initialize(soy, *tags)
        super(*tags)
        @id = soy.id_counter
      end
    end

    class PhiNode < SynthNode
      def to_s
        "#{id} φ"
      end
    end

    class MergeNode < SynthNode
      def to_s
        "#{id} ψ"
      end
    end

    class Edge
      attr_reader :from
      attr_reader :to
      attr_reader :tags

      def initialize(from, to, *tags)
        @from = from
        @to = to
        @tags = tags
      end
    end

    class SubGraph
      attr_reader :first
      attr_reader :last
      attr_reader :in
      attr_reader :out

      def initialize(first, last, inputs, out)
        @first = first
        @last = last
        @in = inputs
        @out = out
      end
    end
  end
end
