module YARV
  # ### Summary
  #
  # `opt_gt` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the > operator is used. Fast paths exist within CRuby when
  # both operands are integers or floats.
  #
  # ### TracePoint
  #
  # `opt_gt` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 4 > 3
  #
  # ~~~
  #
  class OptGt
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
      "%-38s %s%s" % ["opt_gt", call_data, "[CcCr]"]
    end
  end
end
