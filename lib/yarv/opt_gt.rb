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
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,5)> (catch: FALSE)
  # # 0000 putobject                              4                         (   1)[Li]
  # # 0002 putobject                              3
  # # 0004 opt_gt                                 <calldata!mid:>, argc:1, ARGS_SIMPLE>[CcCr]
  # # 0006 leave
  # ~~~
  #
  class OptGt
    def call(context)
      left, right = context.stack.pop(2)

      result = context.call_method(left, :>, [right])
      context.stack.push(result)
    end

    def pretty_print(q)
      q.text("opt_gt <calldata!mid:>, argc:1, ARGS_SIMPLE>")
    end
  end
end
