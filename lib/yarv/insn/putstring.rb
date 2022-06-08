# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putstring` pushes a string literal onto the stack.
  #
  # ### TracePoint
  #
  # `putstring` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # "foo"
  # ~~~
  #
  class PutString < Instruction
    attr_reader :string

    def initialize(string)
      @string = string
    end

    def ==(other)
      other in PutString[string: ^(string)]
    end

    def call(context)
      context.stack.push(string)
    end

    def deconstruct_keys(keys)
      { string: }
    end

    def disasm(iseq)
      "%-38s %s" % ["putstring", string.inspect]
    end
  end
end
