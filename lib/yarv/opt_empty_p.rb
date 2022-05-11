# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_empty_p` is an optimization applied when the method `empty?` is called
  # on a String, Array or a Hash. This optimization can be applied because Ruby
  # knows how to calculate the length of these objects using internal C macros.
  #
  # ### TracePoint
  #
  # `opt_empty_p` can dispatch `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "".empty?
  #
  # ~~~
  #
  class OptEmptyP
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def to_s
      "%-38s %s%s" % ["opt_empty_p", call_data, "[CcCr]"]
    end
  end
end
