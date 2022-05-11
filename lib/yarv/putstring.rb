# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putstring` pushes a string literal onto the stack.
  #
  # ### TracePoint
  #
  # `putstring` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # "foo"
  #
  # ~~~
  #
  class PutString
    attr_reader :string

    def initialize(string)
      @string = string
    end

    def call(context)
      context.stack.push(string)
    end

    def to_s
      "%-38s %s" % ["putstring", string.inspect]
    end
  end
end
