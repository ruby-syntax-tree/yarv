# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `intern` converts top element from stack to a symbol.
  #
  # ### TracePoint
  #
  # There is no trace point for `intern`.
  #
  # ### Usage
  #
  # ~~~ruby
  # :"#{"foo"}"
  #
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
