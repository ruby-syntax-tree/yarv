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
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def call(context)
      result = context.call_method(value, :freeze, [])
      context.stack.push(result)
    end

    def pretty_print(q)
      q.text(
        "opt_str_freeze #{value.inspect} <calldata!mid:freeze, argc:0, ARGS_SIMPLE>"
      )
    end
  end
end
