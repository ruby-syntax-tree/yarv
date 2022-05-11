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
  # ~~~
  #
  class Pop
    def call(context)
      context.stack.pop
    end

    def to_s
      "pop"
    end
  end
end
