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
  # ~~~
  #
  class Dup
    def ==(other)
      other in Dup
    end

    def call(context)
      value = context.stack.pop
      context.stack.push(value)
      context.stack.push(value)
    end

    def to_s
      "dup"
    end
  end
end
