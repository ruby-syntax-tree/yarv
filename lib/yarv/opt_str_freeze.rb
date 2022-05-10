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
  # 'hello'.freeze
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,14)> (catch: FALSE)
  # # 0000 opt_str_freeze                         "hello", <calldata!mid:freeze, argc:0, ARGS_SIMPLE>(   1)[Li]
  # # 0003 leave
  # ~~~
  #
  class OptStrFreeze
    attr_reader :value, :call_data

    def initialize(value, call_data)
      @value = value
      @call_data = call_data
    end

    def call(context)
      result = context.call_method(call_data, value, [])
      context.stack.push(result)
    end

    def to_s
      "%-38s %s, %s" % ["opt_str_freeze", value.inspect, call_data]
    end
  end
end
