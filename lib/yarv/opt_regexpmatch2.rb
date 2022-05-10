# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_regexpmatch2` is a specialization of the `opt_send_without_block` instruction
  # that occurs when the `=~` operator is used.
  #
  # ### TracePoint
  #
  # `opt_regexpmatch2` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # /a/ =~ "a"
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,10)> (catch: FALSE)
  # 0000 putobject                              /a/                       (   1)[Li]
  # 0002 putstring                              "a"
  # 0004 opt_regexpmatch2                       <calldata!mid:=~, argc:1, ARGS_SIMPLE>[CcCr]
  # 0006 leave
  # ~~~
  #
  class OptRegexpmatch2
    def call(context)
      left, right = context.stack.pop(2)

      result = context.call_method(left, :=~, [right])
      context.stack.push(result)
    end

    def pretty_print(q)
      q.text("opt_regexpmatch2 <calldata!mid:=~, argc:1, ARGS_SIMPLE>")
    end
  end
end
