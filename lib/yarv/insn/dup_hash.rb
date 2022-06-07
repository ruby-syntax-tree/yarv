# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `duphash` pushes a hash onto the stack
  #
  # ### TracePoint
  #
  # `duphash` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # { a: 1 }
  # ~~~
  #
  class DupHash < Insn
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def ==(other)
      other in DupHash[value: ^(value)]
    end

    def call(context)
      context.stack.push(value.dup)
    end

    def deconstruct_keys(keys)
      { value: }
    end

    def disasm(iseq)
      "%-38s %s" % ["duphash", value.inspect]
    end
  end
end
