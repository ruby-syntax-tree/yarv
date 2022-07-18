# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `expandarray` looks at the top of the stack, and if the value is an array
  # it replaces it on the stack with `num` elements of the array, or `nil` if
  # the elements are missing.
  #
  # ### TracePoint
  #
  # `dup` does not dispatch any events.
  #
  class ExpandArray < Instruction
    attr_reader :size, :flag

    def initialize(size, flag)
      @size = size
      @flag = flag
    end

    def ==(other)
      other in ExpandArray[size: ^(size), flag: ^(flag)]
    end

    def call(context)
      raise # see vm_expandarray, it's a little subtle
    end

    def reads
      1
    end

    def writes
      size
    end

    def disasm(iseq)
      "%-38s %d, %d" % ["expandarray", size, flag]
    end

    def deconstruct_keys(keys)
      { size:, flag: }
    end
  end
end
