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
  # value = 5; value
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,16)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] value@0
  # # 0000 putobject                              5                         (   1)[Li]
  # # 0002 setlocal_WC_0                          value@0
  # # 0004 getlocal_WC_0                          value@0
  # # 0006 leave
  #
  class GetLocalWC0
    attr_reader :name, :index

    def initialize(name, index)
      @name = name
      @index = index
    end

    def call(context)
      value = context.current_frame.get_local(index)
      context.stack.push(value)
    end

    def pretty_print(q)
      q.text("getlocal_WC_0 #{name}@0")
    end
  end
end
