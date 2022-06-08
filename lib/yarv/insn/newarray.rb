# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `newarray` puts a new array initialized with `size` values from the stack.
  #
  # ### TracePoint
  #
  # `newarray` dispatches a `line` event.
  #
  # ### Usage
  #
  # ~~~ruby
  # ["string"]
  # ~~~
  #
  class NewArray < Instruction
    attr_reader :size

    def initialize(size)
      @size = size
    end

    def ==(other)
      other in NewArray[size: ^(size)]
    end

    def call(context)
      array = context.stack.pop(size)
      context.stack.push(array)
    end

    def deconstruct_keys(keys)
      { size: }
    end

    def disasm(iseq)
      "%-38s %s" % ["newarray", size]
    end
  end
end
