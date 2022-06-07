# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `setlocal_WC_0` is a specialized version of the `setlocal` instruction. It
  # sets the value of a local variable on the current frame to the value at the
  # top of the stack as determined by the index given as its only argument.
  #
  # ### TracePoint
  #
  # `setlocal_WC_0` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # value = 5
  # ~~~
  #
  class SetLocalWC0 < Insn
    attr_reader :name, :index

    def initialize(name, index)
      @name = name
      @index = index
    end

    def ==(other)
      other in SetLocalWC0[name: ^(name), index: ^(index)]
    end

    def call(context)
      value = context.stack.pop
      context.current_frame.set_local(index, value)
    end

    def disasm(iseq)
      "%-38s %s@%d" % ["setlocal_WC_0", name, index]
    end
  end
end
