# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `pop` pops the top value off the stack.
  #
  # ### TracePoint
  #
  # `pop` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # a ||= 2
  # ~~~
  #
  class Pop < Instruction
    def ==(other)
      other in Pop
    end

    def call(context)
      context.stack.pop
    end

    def disasm(iseq)
      "pop"
    end
  end
end
