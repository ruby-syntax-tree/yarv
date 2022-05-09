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
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,5)> (catch: FALSE)                                      │~
  # # 0000 putobject                              2                         (   1)[Li]                           │~
  # # 0002 putobject                              3                                                              │~
  # # 0004 opt_and                                <calldata!mid:&, argc:1, ARGS_SIMPLE>[CcCr]                    │~
  # # 0006 leave
  #
  # ~~~
  #
  class OptAnd
    def call(context)
      left, right = context.stack.pop(2)
      context.stack.push(left & right)
    end

    def pretty_print(q)
      q.text("opt_and <calldata!mid:&, argc:1, ARGS_SIMPLE>")
    end
  end
end
