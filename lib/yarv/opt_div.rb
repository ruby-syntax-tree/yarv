# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_div` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the `/` operator is used. In CRuby, there are fast paths
  # for if both operands are integers, or if both operands are floats.
  #
  # ### TracePoint
  #
  # `opt_div` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 2 / 3
  # ~~~
  #
  class OptDiv
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def to_s
      "%-38s %s%s" % ["opt_div", call_data, "[CcCr]"]
    end
  end
end
