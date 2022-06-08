# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_str_uminus` pushes a frozen known string value with no interpolation
  # onto the stack.
  #
  # ### TracePoint
  #
  # `opt_str_uminus` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # -"string"
  # ~~~
  #
  class OptStrUMinus < Instruction
    attr_reader :value, :call_data

    def initialize(value, call_data)
      @value = value
      @call_data = call_data
    end

    def ==(other)
      other in OptStrUMinus[value: ^(value), call_data: ^(call_data)]
    end

    def call(context)
      arguments = context.stack.pop(call_data.argc)
      result = context.call_method(call_data, value, arguments)

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { value:, call_data: }
    end

    def disasm(iseq)
      "%-38s %s, %s" % ["opt_str_uminus", value.inspect, call_data]
    end
  end
end
