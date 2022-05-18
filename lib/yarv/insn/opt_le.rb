module YARV
  # ### Summary
  #
  # `opt_le` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the <= operator is used. Fast paths exist within CRuby when
  # both operands are integers or floats.
  #
  # ### TracePoint
  #
  # `opt_le` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 3 <= 4
  # ~~~
  #
  class OptLe
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptLe[call_data: ^(call_data)]
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
      "%-38s %s%s" % ["opt_le", call_data, "[CcCr]"]
    end
  end
end
