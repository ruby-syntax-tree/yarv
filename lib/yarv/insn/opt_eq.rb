module YARV
  # ### Summary
  #
  # `opt_eq` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the == operator is used. Fast paths exist within CRuby when
  # both operands are integers, floats, symbols or strings.
  #
  # ### TracePoint
  #
  # `opt_eq` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 2 == 2
  # ~~~
  #
  class OptEq < Insn
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptEq[call_data: ^(call_data)]
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
      "%-38s %s%s" % ["opt_eq", call_data, "[CcCr]"]
    end
  end
end
