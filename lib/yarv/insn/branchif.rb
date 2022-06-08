# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `branchif` has one argument: the jump index. It pops one value off the stack:
  # the jump condition.
  #
  # If the value popped off the stack is true, `branchif` jumps to
  # the jump index and continues executing there.
  #
  # ### TracePoint
  #
  # `branchif` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # x = true
  # x ||= "foo"
  # puts x
  # ~~~
  #
  class BranchIf < Instruction
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def ==(other)
      other in BranchIf # explicitly not comparing labels
    end

    def call(context)
      condition = context.stack.pop

      if condition
        jump_index = context.current_iseq.labels[label]
        context.program_counter = jump_index
      end
    end

    def deconstruct_keys(keys)
      { label: }
    end

    def branches?
      true
    end

    def falls_through?
      true
    end

    def reads
      1
    end

    def writes
      0
    end

    def disasm(iseq)
      target = iseq ? iseq.labels[label] : "??"
      "%-38s %s (%s)" % ["branchif", label, target]
    end
  end
end
