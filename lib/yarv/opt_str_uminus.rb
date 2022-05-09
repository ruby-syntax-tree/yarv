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
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,6)> (catch: FALSE)
  # # 0000 opt_str_uminus                         "string", <calldata!mid:-@, argc:0, ARGS_SIMPLE>(   1)[Li]
  # # 0003 leave
  # ~~~
  #
  class OptStrUMinus
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def call(context)
      context.stack.push(-value)
    end

    def pretty_print(q)
      q.text("opt_str_uminus #{value.inspect} <calldata!mid:-@, argc:0, ARGS_SIMPLE>")
    end
  end
end
