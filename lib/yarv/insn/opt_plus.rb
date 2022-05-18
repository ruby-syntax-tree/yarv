# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_plus` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the `+` operator is used. In CRuby, there are fast paths
  # for if both operands are integers, floats, strings, or arrays.
  #
  # ### TracePoint
  #
  # `opt_plus` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 2 + 3
  # ~~~
  #
  class OptPlus
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptPlus[call_data: ^(call_data)]
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
      "%-38s %s%s" % ["opt_plus", call_data, "[CcCr]"]
    end
  end
end
