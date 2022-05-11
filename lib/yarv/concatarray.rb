# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `concatarray` concatenates the two Arrays on top of the stack.
  #
  # It coerces the two objects at the top of the stack into Arrays by calling
  # `to_a` if necessary, and makes sure to `dup` the first Array if it was
  # already an Array, to avoid mutating it when concatenating.
  #
  # ### TracePoint
  #
  # `concatarray` can dispatch the `line` and `call` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # [1, *2]
  # ~~~
  #
  class ConcatArray
    def call(context)
      left, right = context.stack.pop(2)
      coerced_left = coerce(left)
      coerced_left = left.dup if coerced_left.equal?(left)
      coerced_left.concat(coerce(right))
      context.stack.push(coerced_left)
    end

    def to_s
      "concatarray"
    end

    private

    def coerce(object)
      object.respond_to?(:to_a) ? object.to_a : [object]
    end
  end
end
