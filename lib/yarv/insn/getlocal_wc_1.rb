# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `getlocal_WC_1` is a specialized version of the `getlocal` instruction. It
  # fetches the value of a local variable from the parent frame determined by
  # the index given as its only argument.
  #
  # ### TracePoint
  #
  # `getlocal_WC_1` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # value = 5
  # self.then { value }
  # ~~~
  #
  class GetLocalWC1
    attr_reader :name, :index

    def initialize(name, index)
      @name = name
      @index = index
    end

    def ==(other)
      other in GetLocalWC1[name: ^(name), index: ^(index)]
    end

    def call(context)
      value = context.parent_frame.get_local(index)
      context.stack.push(value)
    end

    def deconstruct_keys(keys)
      { name:, index: }
    end

    def to_s
      "%-38s %s@%d" % ["getlocal_WC_1", name, index]
    end
  end
end
