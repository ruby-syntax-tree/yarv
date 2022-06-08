# frozen_string_literal: true

module YARV
  # Constructs a control-flow-graph, or CFG, of a YARV instruction sequence.
  # We use conventional basic-blocks.
  class CFG
    attr_reader :iseq
    attr_reader :blocks
    attr_reader :block_map

    def initialize(iseq)
      if iseq.throw_handlers.any?
        raise "throw handlers not supported in CFG yet"
      end

      @iseq = iseq

      block_starts = find_block_starts(iseq)

      # Find basic blocks.
      @blocks =
        block_starts.map do |start|
          stop =
            (block_starts.select { |n| n > start } + [iseq.insns.length]).min
          length = stop - start
          last_insn = iseq.insns[start + length - 1]
          BasicBlock.new(self, start, length, last_insn.leaves?)
        end

      # Create a map of PCs of basic block starts, to basic block objects.
      @block_map = @blocks.map { |block| [block.start, block] }.to_h

      # Connect blocks with the preds and succs.
      @blocks.each do |block|
        last_insn = iseq.insns[block.start + block.length - 1]
        if last_insn.branches? && last_insn.respond_to?(:label)
          block.succs << block_map[iseq.labels[last_insn.label]]
        end
        if (!last_insn.branches? && !last_insn.leaves?) ||
             last_insn.falls_through?
          block.succs << block_map[block.start + block.length]
        end
        block.succs.each { |succ| succ.preds << block }
      end
    end

    def disasm(output = StringIO.new, prefix = "")
      output.puts prefix + iseq.disasm_header("cfg")
      blocks.each { |block| block.disasm output, prefix }
      output.string
    end

    private

    # Find all the instructions that start a basic block, because they're
    # either the start of an ISEQ, or they're the target of a branch, or
    # they are fallen through to from a branch.
    def find_block_starts(iseq)
      starts = Set.new([0])
      iseq.insns.each_with_index do |insn, insn_pc|
        if insn.branches? && insn.respond_to?(:label)
          starts.add iseq.labels[insn.label]
        end
        starts.add insn_pc + 1 if insn.falls_through?
      end
      starts.to_a.sort
    end

    class BasicBlock
      attr_reader :cfg
      attr_reader :start
      attr_reader :length
      attr_reader :preds
      attr_reader :succs

      def initialize(cfg, start, length, leaves)
        @cfg = cfg
        @start = start
        @length = length
        @preds = []
        @succs = []
        @leaves = leaves
      end

      def disasm(output, prefix)
        disasm_block_header output, prefix
        disasm_block_body output, prefix
      end

      def disasm_block_header(output, prefix)
        output.print "#{prefix}block_#{start}:"
        unless preds.empty?
          output.print " # from: #{preds.map { |b| "block_#{b.start}" }.join(", ")}"
        end
        output.puts
      end

      def disasm_block_body(output, prefix)
        cfg.iseq.insns[
          start...start + length
        ].each_with_index do |insn, insn_rel_pc|
          insn_pc = start + insn_rel_pc
          output.print prefix
          output.print "    "
          output.print cfg.iseq.disasm_insn(insn, insn_pc)
          output.print yield(insn, insn_rel_pc) if block_given?
          output.puts
        end
        all_succs = succs.map { |b| "block_#{b.start}" }
        all_succs.push "leaves" if leaves?
        unless all_succs.empty?
          output.print prefix
          output.print "        # to: #{all_succs.join(", ")}"
          output.puts
        end
      end

      def leaves?
        @leaves
      end
    end
  end
end
