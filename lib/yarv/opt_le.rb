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
  #
  #  # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,6)> (catch: FALSE)
  # # 0000 putobject                              3                         (   1)[Li]
  # # 0002 putobject                              4
  # # 0004 opt_le                                 <calldata!mid:<=, argc:1, ARGS_SIMPLE>[CcCr]
  # # 0006 leave
  # ~~~
  #
  class OptLe
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def pretty_print(q)
      q.text("opt_le <calldata!mid:<=, argc:1, ARGS_SIMPLE>")
    end
  end
end
