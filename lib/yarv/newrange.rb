# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `newrange` creates a Range. It takes one arguments, which is 0 if the end
  # is included or 1 if the end value is excluded.
  #
  # ### TracePoint
  #
  # `newrange` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # x = 0
  # y = 1
  # p (x..y), (x...y)
  # ~~~
  #
  class NewRange
    def initialize(exclude_end)
      unless exclude_end == 0 || exclude_end == 1
        raise ArgumentError, "invalid exclude_end: #{exclude_end.inspect}"
      end
      @exclude_end = exclude_end
    end

    attr_reader :exclude_end

    def call(context)
      range_begin, range_end = context.stack.pop(2)
      context.stack.push(Range.new(range_begin, range_end, exclude_end == 1))
    end

    def to_s
      "%-38s %d" % ["newrange", exclude_end]
    end
  end
end
