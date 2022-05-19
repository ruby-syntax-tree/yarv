# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `adjuststack` accepts a single integer argument and removes that many
  # elements from the top of the stack.
  #
  # ### TracePoint
  #
  # `adjuststack` cannot dispatch any TracePoint events.
  #
  # ### Usage
  #
  # ~~~ruby
  # x = [true]
  # x[0] ||= nil
  # x[0]
  # ~~~
  #
  class AdjustStack
    attr_reader :size

    def initialize(size)
      @size = size
    end

    def ==(other)
      other in AdjustStack
    end

    def call(context)
      context.stack.pop(size)
    end

    def deconstruct_keys(keys)
      { size: }
    end

    def to_s
      "%-38s %d" % ["adjuststack", size]
    end
  end
end
