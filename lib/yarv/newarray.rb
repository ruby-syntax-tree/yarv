# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `newarray` puts a new array initialized with `size` values from the stack.
  #
  # ### TracePoint
  #
  # `newarray` dispatches a `line` event.
  #
  # ### Usage
  #
  # ~~~ruby
  # ["string"]
  # ~~~
  #
  class NewArray
    attr_reader :size

    def initialize(size)
      @size = size
    end

    def call(context)
      array = context.stack.pop(size)
      context.stack.push(array)
    end

    def to_s
      "%-38s %s" % ["newarray", size]
    end
  end
end
