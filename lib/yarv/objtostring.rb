# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `objtostring` pops a value from the stack, calls `to_s` on that value and then pushes
  # the result back to the stack.
  #
  # It has fast paths for String, Symbol, Module, Class, Nil, True, False & Number.
  # For everything else it calls `to_s`
  #
  # ### TracePoint
  #
  # `objtostring` cannot dispatch any TracePoint events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "#{5}"
  #
  # ~~~
  #
  class ObjToString
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def call(context)
      obj = context.stack.pop
      result = context.call_method(call_data, obj, [])

      context.stack.push(result)
    end

    def to_s
      "%-38s %s" % ["objtostring", call_data]
    end
  end
end
