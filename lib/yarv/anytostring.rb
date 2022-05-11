# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `anytostring` ensures that the value on top of the stack is a string.
  #
  # It pops two values off the stack. If the first value is a string it pushes it back on
  # the stack. If the first value is not a string, it uses Ruby's built in string coercion
  # to coerce the second value to a string and then pushes that back on the stack.
  #
  # This is used in conjunction with `objtostring` as a fallback for when an object's `to_s`
  # method does not return a string
  #
  # ### TracePoint
  #
  # `anytostring` cannot dispatch any TracePoint events
  #
  # ### Usage
  #
  # ~~~ruby
  # "#{5}"
  #
  # ~~~
  #
  class AnyToString
    def call(context)
      maybe_string, orig_val = context.stack.pop(2)
      string = maybe_string.is_a?(String) ? maybe_string : orig_val.to_s
      context.stack.push(string)
    end

    def to_s
      "anytostring"
    end
  end
end
