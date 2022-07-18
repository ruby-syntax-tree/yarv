# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `dup` copies the top value of the stack and pushes it onto the stack.
  #
  # ### TracePoint
  #
  # `dup` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # $global = 5
  # ~~~
  #
  class Dup < Instruction
    def ==(other)
      other in Dup
    end

    def reads
      1
    end

    def writes
      2
    end

    def side_effects?
      false
    end

    def call(context)
      value = context.stack.pop
      context.stack.push(value)
      context.stack.push(value)
    end

    def disasm(iseq)
      "dup"
    end
  end
end
