# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_and` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the `&` operator is used. In CRuby, there are fast paths
  # for if both operands are integers.
  #
  # ### TracePoint
  #
  # `opt_and` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 2 & 3
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,5)> (catch: FALSE)
  # # 0000 putobject                              2                         (   1)[Li]
  # # 0002 putobject                              3
  # # 0004 opt_and                                <calldata!mid:&, argc:1, ARGS_SIMPLE>[CcCr]
  # # 0006 leave
  # ~~~
  #
  class OptAnd
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
      "%-38s %s%s" % ["opt_and", call_data, "[CcCr]"]
    end
  end
end
