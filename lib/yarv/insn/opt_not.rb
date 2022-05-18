# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_not` negates the value on top of the stack.
  #
  # ### TracePoint
  #
  # `opt_not` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # !true
  # ~~~
  #
  class OptNot
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptNot[call_data: ^(call_data)]
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { call_data: }
    end

    def to_s
      "%-38s %s%s" % ["opt_not", call_data, "[CcCr]"]
    end
  end
end
