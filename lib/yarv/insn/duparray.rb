# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `duparray` copies a literal Array and pushes it onto the stack.
  #
  # ### TracePoint
  #
  # `duparray` can dispatch the `line` event.
  #
  # ### Usage
  #
  # ~~~ruby
  # [true]
  # ~~~
  #
  class DupArray
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def ==(other)
      other in DupArray[value: ^(value)]
    end

    def call(context)
      context.stack.push(value.dup)
    end

    def deconstruct_keys(keys)
      { value: }
    end

    def to_s
      "%-38s %s" % ["duparray", value.inspect]
    end
  end
end
