# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `setlocal_WC_1` is a specialized version of the `setlocal` instruction. It
  # sets the value of a local variable on the parent frame to the value at the
  # top of the stack as determined by the index given as its only argument.
  #
  # ### TracePoint
  #
  # `setlocal_WC_1` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # value = 5
  # self.then { value = 10 }
  # ~~~
  #
  class SetLocalWC1 < Instruction
    attr_reader :name, :index

    def initialize(name, index)
      @name = name
      @index = index
    end

    def ==(other)
      other in SetLocalWC1[name: ^(name), index: ^(index)]
    end

    def call(context)
      value = context.stack.pop
      context.parent_frame.set_local(index, value)
    end

    def reads
      1
    end

    def writes
      0
    end

    def disasm(iseq)
      "%-38s %s@%d" % ["setlocal_WC_1", name, index]
    end
  end
end
