# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_succ` is a specialization of the `opt_send_without_block` instruction
  # when the method being called is `succ`. Fast paths exist within CRuby when
  # the receiver is either a String or a Fixnum.
  #
  # ### TracePoint
  #
  # `opt_succ` can dispatch `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "".succ
  # ~~~
  #
  class OptSucc
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
      "%-38s %s%s" % ["opt_succ", call_data, "[CcCr]"]
    end
  end
end
