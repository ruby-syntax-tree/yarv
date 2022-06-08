# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `swap` swaps the top two elements in the stack.
  #
  # ### TracePoint
  #
  # `swap` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # !!defined?([[]])
  # ~~~
  #
  class Swap < Instruction
    def ==(other)
      other in Swap
    end

    def call(context)
      left, right = context.stack.pop(2)
      context.stack.push(right)
      context.stack.push(left)
    end

    def disasm(iseq)
      "swap"
    end
  end
end
