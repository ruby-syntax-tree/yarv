# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_minus` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the `-` operator is used. In CRuby, there are fast paths
  # for if both operands are integers or both operands are floats.
  #
  # ### TracePoint
  #
  # `opt_minus` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 3 - 2
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,5)> (catch: FALSE)
  # # 0000 putobject                              3                         (   1)[Li]                                  
  # # 0002 putobject                              2                                                                     
  # # 0004 opt_minus                              <calldata!mid:-, argc:1, ARGS_SIMPLE>[CcCr]                           
  # # 0006 leave  
  # ~~~
  #
  class OptMinus
    def execute(context)
      left, right = context.stack.pop(2)
      context.stack.push(left - right)
    end

    def pretty_print(q)
      q.text("opt_minus <calldata!mid:-, argc:1, ARGS_SIMPLE>")
    end
  end
end
