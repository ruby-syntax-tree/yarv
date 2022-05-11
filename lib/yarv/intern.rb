# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `intern` converts top element from stack to a symbol.
  #
  # ### TracePoint
  #
  # TODO
  #
  # ### Usage
  #
  # ~~~ruby
  # :"#{"foo"}"
  #
  # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,11)> (catch: FALSE)
  #  0000 putstring                              "foo"                     (   1)[Li]
  #  0002 intern
  #  0003 leave
  # ~~~
  #
  class Intern
    def call(context)
      string = context.stack.pop
      context.stack.push(string.to_sym)
    end

    def to_s
      "intern"
    end
  end
end
