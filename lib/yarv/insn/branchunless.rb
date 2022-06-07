# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `branchunless` has one argument, the jump index
  # and pops one value off the stack, the jump condition.
  #
  # If the value popped off the stack is false or nil,
  # `branchunless` jumps to the jump index and continues executing there.
  #
  # ### TracePoint
  #
  # `branchunless` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # if 2 + 3
  #   puts "foo"
  # end
  # ~~~
  #
  class BranchUnless < Insn
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def ==(other)
      other in BranchUnless # explicitly not comparing labels
    end

    def call(context)
      condition = context.stack.pop

      unless condition
        jump_index = context.current_iseq.labels[label]
        context.program_counter = jump_index
      end
    end

    def deconstruct_keys(keys)
      { label: }
    end

    def disasm(iseq)
      target = iseq ? iseq.labels[label] : "??"
      "%-38s %s (%s)" % ["branchunless", label, target]
    end
  end
end
