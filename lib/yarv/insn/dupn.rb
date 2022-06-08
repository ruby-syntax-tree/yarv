# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `dupn` duplicates the top `n` stack elements.
  #
  # ### TracePoint
  #
  # `dupn` does not dispatch any TracePoint events.
  #
  # ### Usage
  #
  # ~~~ruby
  # Object::X ||= true
  # ~~~
  #
  class DupN < Instruction
    attr_reader :offset

    def initialize(offset)
      @offset = offset
    end

    def ==(other)
      other in DupN[offset: ^(offset)]
    end

    def call(context)
      context.stack.concat(context.stack[-offset..].map(&:dup))
    end

    def deconstruct_keys(keys)
      { offset: }
    end

    def disasm(iseq)
      "%-38s %d" % ["dupn", offset]
    end
  end
end
