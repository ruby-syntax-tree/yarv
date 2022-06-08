# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `jump` has one argument, the jump index, which it uses to set the next
  # instruction to execute.
  #
  # ### TracePoint
  #
  # There is no trace point for `jump`.
  #
  # ### Usage
  #
  # ~~~ruby
  # y = 0
  # if y == 0
  #   puts "0"
  # else
  #   puts "2"
  # end
  # ~~~
  #
  class Jump < Instruction
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def ==(other)
      other in Jump # explicitly not comparing labels
    end

    def call(context)
      jump_index = context.current_iseq.labels[label]
      context.program_counter = jump_index
    end

    def deconstruct_keys(keys)
      { label: }
    end

    def branches?
      true
    end

    def disasm(iseq)
      target = iseq ? iseq.labels[label] : "??"
      "%-38s %s (%s)" % ["jump", label, target]
    end
  end
end
