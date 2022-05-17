# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `branchnil` has one argument: the jump index. It pops one value off the stack:
  # the jump condition.
  #
  # If the value popped off the stack is nil, `branchnil` jumps to
  # the jump index and continues executing there.
  #
  # ### TracePoint
  #
  # There is no trace point for `branchnil`.
  #
  # ### Usage
  #
  # ~~~ruby
  # x = nil
  # if x&.to_s
  #   puts "hi"
  # end
  # ~~~
  #
  class BranchNil
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def ==(other)
      other in BranchNil[label: ^(label)]
    end

    def call(context)
      condition = context.stack.pop

      if condition.nil?
        jump_index = context.current_iseq.labels[label]
        context.program_counter = jump_index
      end
    end

    def deconstruct_keys(keys)
      { label: }
    end

    def to_s
      "%-38s %s" % ["branchnil", label["label_".length..]]
    end
  end
end
