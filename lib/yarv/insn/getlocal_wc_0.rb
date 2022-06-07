# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `getlocal_WC_0` is a specialized version of the `getlocal` instruction. It
  # fetches the value of a local variable from the current frame determined by
  # the index given as its only argument.
  #
  # ### TracePoint
  #
  # `getlocal_WC_0` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # value = 5
  # value
  # ~~~
  #
  class GetLocalWC0 < Insn
    attr_reader :name, :index

    def initialize(name, index)
      @name = name
      @index = index
    end

    def ==(other)
      other in GetLocalWC0[name: ^(name), index: ^(index)]
    end

    def call(context)
      value = context.current_frame.get_local(index)
      context.stack.push(value)
    end

    def deconstruct_keys(keys)
      { name:, index: }
    end

    def disasm(iseq)
      "%-38s %s@%d" % ["getlocal_WC_0", name, index]
    end
  end
end
