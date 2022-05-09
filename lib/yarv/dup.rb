# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `dup` copies the top value of the stack and pushes it onto the stack.
  #
  # ### TracePoint
  #
  # `dup` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # $global = 5
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,11)> (catch: FALSE)
  # # 0000 putobject                              5                         (   1)[Li]
  # # 0002 dup
  # # 0003 setglobal                              :$global
  # # 0005 leave
  # ~~~
  #
  class Dup
    def call(context)
      value = context.stack.pop
      context.stack.push(value)
      context.stack.push(value)
    end

    def pretty_print(q)
      q.text("dup")
    end
  end
end
