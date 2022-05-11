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
  class Swap
    def call(context)
      left, right = context.stack.pop(2)
      context.stack.push(right)
      context.stack.push(left)
    end

    def to_s
      "swap"
    end
  end
end
