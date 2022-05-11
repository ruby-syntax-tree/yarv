# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `swap` swaps the top two elements in the stack.
  #
  # ### TracePoint
  #
  # `swap` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # !!defined?([[]])
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,16)> (catch: TRUE)
  # # == catch table
  # # | catch type: rescue st: 0001 ed: 0003 sp: 0000 cont: 0005
  # # | == disasm: #<ISeq:defined guard in <main>@-e:0 (0,0)-(-1,-1)> (catch: FALSE)
  # # | local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # | [ 1] "\#$!"@0
  # # | 0000 putnil
  # # | 0001 leave
  # # |------------------------------------------------------------------------
  # # 0000 putnil                                                           (   1)[Li]
  # # 0001 putobject                    "expression"
  # # 0003 swap
  # # 0004 pop
  # # 0005 opt_not                      <callinfo!mid:!, argc:0, ARGS_SIMPLE>, <callcache>
  # # 0008 opt_not                      <callinfo!mid:!, argc:0, ARGS_SIMPLE>, <callcache>
  # # 0011 leave
  # ~~~
  #
  class Swap
    def call(context)
      left, right = context.stack.pop(2)
      context.stack.push(right)
      context.stack.push(left)
    end

    def to_s
      "swap"
    end
  end
end
