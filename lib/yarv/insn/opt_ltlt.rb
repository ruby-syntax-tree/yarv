module YARV
  # ### Summary
  #
  # `opt_ltlt` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the `<<` operator is used. Fast paths exists when the
  # receiver is either a String or an Array
  #
  # ### TracePoint
  #
  # `opt_ltlt` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "" << 2
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,7)> (catch: FALSE)
  # # 0000 putstring                              ""                        (   1)[Li]
  # # 0002 putobject                              2
  # # 0004 opt_ltlt                               <calldata!mid:<<, argc:1, ARGS_SIMPLE>[CcCr]
  # # 0006 leave
  # ~~~
  #
  class OptLtLt < Insn
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptLtLt[call_data: ^(call_data)]
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { call_data: }
    end

    def disasm(iseq)
      "%-38s %s%s" % ["opt_ltlt", call_data, "[CcCr]"]
    end
  end
end
