# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_str_freeze` pushes a frozen known string value with no interpolation
  # onto the stack.
  #
  # ### TracePoint
  #
  # `opt_str_freeze` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "hello".freeze
  # ~~~
  #
  class OptStrFreeze < Insn
    attr_reader :value, :call_data

    def initialize(value, call_data)
      @value = value
      @call_data = call_data
    end

    def ==(other)
      other in OptStrFreeze[value: ^(value), call_data: ^(call_data)]
    end

    def call(context)
      result = context.call_method(call_data, value, [])
      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { value:, call_data: }
    end

    def disasm(iseq)
      "%-38s %s, %s" % ["opt_str_freeze", value.inspect, call_data]
    end
  end
end
