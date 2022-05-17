# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_minus` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the `-` operator is used. In CRuby, there are fast paths
  # for if both operands are integers or both operands are floats.
  #
  # ### TracePoint
  #
  # `opt_minus` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 3 - 2
  # ~~~
  #
  class OptMinus
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptMinus[call_data: ^(call_data)]
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { call_data: }
    end

    def to_s
      "%-38s %s%s" % ["opt_minus", call_data, "[CcCr]"]
    end
  end
end
