# frozen_string_literal: true

module YARV
  # Constructs a data-flow-graph, or DFG, of a YARV instruction sequence, via
  # a CFG. We use basic-blog-arguments. Dataflow is discovered locally and then
  # globally. The graph only considers dataflow through the stack - local
  # variables anre objects are considered fully escaped in this analysis.
  class DFG
    attr_reader :cfg
    attr_reader :insn_flow
    attr_reader :block_flow

    def initialize(cfg)
      if cfg.iseq.throw_handlers.any?
        raise "throw handlers not supported in DFG yet"
      end

      @cfg = cfg
      @insn_flow = {}

      # Create a side data structure to encode dataflow between instructions.
      @insn_flow = {}
      cfg.iseq.insns.each_with_index do |insn, insn_pc|
        insn_flow[insn_pc] = Dataflow.new
      end

      # Create a side data structure to encode dataflow between basic blocks.
      @block_flow = {}
      cfg.blocks.each { |block| @block_flow[block.start] = Dataflow.new }

      # Discover the dataflow.
      local_flow
      global_flow
      verify_flow
    end

    # Graph dataflow within basic blocks.
    def local_flow
      # Using an abstract stack, connect from consumers to producers.
      cfg.blocks.each do |block|
        block_dataflow = block_flow[block.start]

        stack = []
        stack_initial_depth = 0

        # Go through each instruction in the block...
        block
          .start
          .upto(block.start + block.length - 1) do |insn_pc|
            insn = cfg.iseq.insns[insn_pc]
            insn_dataflow = insn_flow[insn_pc]

            # For every value the instruction pops off the stack...
            insn.reads.times do
              # Was the value it pops off from another basic block?
              if stack.empty?
                # Thi is a basic block argument.
                name = :"in_#{stack_initial_depth}"
                insn_dataflow.in << name
                block_dataflow.in << name
                stack_initial_depth += 1
              else
                # Connect this consumer to the producer of the value.
                insn_dataflow.in << stack.pop
              end
            end

            # Record on our abstract stack that this instruction pushed
            # this value onto the stack.
            insn.writes.times { stack.push insn_pc }
          end

        # Values that are left on the stack after going through all
        # instructions are arguments to the basic block that we jump to.
        stack.reverse.each_with_index do |producer, n|
          block_dataflow.out << producer
          producer_dataflow = insn_flow[producer]
          producer_dataflow.out << :"out_#{n}"
        end
      end

      # Go backwards and connect from producers to consumers.
      cfg.iseq.insns.each_with_index do |insn, insn_pc|
        insn_dataflow = insn_flow[insn_pc]
        # For every instruction that produced a value used in this
        # instruction...
        insn_dataflow.in.each do |producer|
          # If it's actually another instruction and not a basic block
          # argument...
          if producer.is_a?(Integer)
            # Record in the producing instruction that it produces a value
            # used by this construction.
            producer_dataflow = insn_flow[producer]
            producer_dataflow.out << insn_pc
          end
        end
      end
    end

    # Graph dataflow between basic blocks.
    def global_flow
      # Go through a worklist of all basic blocks...
      worklist = cfg.blocks.dup
      until worklist.empty?
        succ = worklist.pop
        succ_flow = block_flow[succ.start]
        succ.preds.each do |pred|
          pred_flow = block_flow[pred.start]

          # Does a predecessor block have fewer outputs than the successor
          # has inputs?
          if pred_flow.out.size < succ_flow.in.size
            # If so then add arguments to pass data through from the
            # predecessor's redecessors.
            (succ_flow.in.size - pred_flow.out.size).times do |n|
              name = :"pass_#{n}"
              pred_flow.in.unshift name
              pred_flow.out.unshift name
            end

            # Since we modified the predecessor, add it back to the worklist
            # so it'll be considered as a successor again, and propogate
            # the global dataflow back up the control flow graph.
            worklist.push pred
          end
        end
      end
    end

    def verify_flow
      # Check the first block has no arguments.
      first_block = cfg.blocks.first
      first_blow_flow = block_flow[first_block.start]
      raise unless first_blow_flow.in.size == 0

      # Check all control flow edges between blocks pass the right number of
      # arguments.
      cfg.blocks.each do |pred|
        pred_flow = block_flow[pred.start]
        if pred.succs.empty?
          # With no successors, there should be no output arguments.
          raise unless pred_flow.out.empty?
        else
          # Check with successor...
          pred.succs.each do |succ|
            succ_block = cfg.block_map[succ]
            succ_flow = block_flow[succ.start]
            # The predecessor should have as many output arguments as the
            # success has input arguments.
            raise unless pred_flow.out.size == succ_flow.in.size
          end
        end
      end
    end

    def disasm(output = StringIO.new, prefix = "")
      output.puts prefix + cfg.iseq.disasm_header("dfg")
      cfg.blocks.each do |block|
        block_dataflow = block_flow[block.start]
        block.disasm_block_header output, prefix
        unless block_dataflow.in.empty?
          output.print prefix
          output.puts "        # in: #{disasm_dataflow_connections(block_dataflow.in)}"
        end
        block.disasm_block_body output, prefix do |insn, rel_pc|
          insn_pc = block.start + rel_pc
          insn_dataflow = insn_flow[insn_pc]
          if insn_dataflow.in.empty? && insn_dataflow.out.empty?
            ""
          else
            annotate = " # "
            unless insn_dataflow.in.empty?
              annotate += "in: #{disasm_dataflow_connections(insn_dataflow.in)}"
              annotate += "; " unless insn_dataflow.out.empty?
            end
            unless insn_dataflow.out.empty?
              annotate +=
                "out: #{disasm_dataflow_connections(insn_dataflow.out)}"
            end
            annotate
          end
        end
        unless block_dataflow.out.empty?
          output.print prefix
          output.puts "        # out: #{disasm_dataflow_connections(block_dataflow.out)}"
        end
      end
      output.string
    end

    def disasm_dataflow_connections(connections)
      connections
        .map { |pc| pc.is_a?(Symbol) ? pc : InstructionSequence.disasm_pc(pc) }
        .join(", ")
    end

    class Dataflow
      attr_reader :in
      attr_reader :out

      def initialize
        @in = []
        @out = []
      end
    end
  end
end
