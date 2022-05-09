# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `pop` pops the top value off the stack.
  #
  # ### TracePoint
  #
  # `pop` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # a ||= 2
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,7)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] a@0
  # # 0000 getlocal_WC_0                          a@0                       (   1)[Li]
  # # 0002 dup
  # # 0003 branchif                               11
  # # 0005 pop
  # # 0006 putobject                              2
  # # 0008 dup
  # # 0009 setlocal_WC_0                          a@0
  # # 0011 leave
  # ~~~
  #
  class Pop
    def execute(context)
      context.stack.pop
    end

    def pretty_print(q)
      q.text("pop")
    end
  end
end
