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
  #
  # #== disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,8)> (catch: FALSE)
  # #0000 putstring                              "a"                       (   1)[Li]
  # #0002 opt_succ                               <calldata!mid:succ, argc:0, ARGS_SIMPLE>[CcCr]
  # #0004 leave
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
