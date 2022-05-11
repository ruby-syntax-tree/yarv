# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `concatstrings` just pops a number of strings from the stack joins them together
  # into a single string and pushes that string back on the stack.
  #
  # This does no coercion and so is always used in conjunction with `objtostring`
  # and `anytostring` to ensure the stack contents are always strings
  #
  # ### TracePoint
  #
  # `concatstrings` can dispatch the `line` and `call` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "#{5}"
  #
  # ~~~
  #
  class ConcatStrings
    attr_reader :num

    def initialize(num)
      @num = num
    end

    def call(context)
      strings = context.stack.pop(num)
      context.stack.push(strings.join)
    end

    def to_s
      "%-38s %s" % ["concatstrings", num]
    end
  end
end
