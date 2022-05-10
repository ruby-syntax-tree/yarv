# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_not` negates the value on top of the stack.
  #
  # ### TracePoint
  #
  # `opt_not` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # !true
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,5)> (catch: FALSE)
  # # 0000 putobject                              true                      (   1)[Li]
  # # 0002 opt_not                                <calldata!mid:!, argc:0, ARGS_SIMPLE>[CcCr]
  # # 0004 leave
  # ~~~
  #
  class OptNot
    def call(context)
      obj = context.stack.pop
      context.stack.push(!obj)
    end

    def pretty_print(q)
      q.text("opt_not <calldata!mid:!, argc:0, ARGS_SIMPLE>")
    end
  end
end
