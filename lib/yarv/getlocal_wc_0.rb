# frozen_string_literal: true
require_relative './getlocal'

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
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,16)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] value@0
  # # 0000 putobject                              5                         (   1)[Li]
  # # 0002 setlocal_WC_0                          value@0
  # # 0004 getlocal_WC_0                          value@0
  # # 0006 leave
  # ~~~
  #
  class GetLocalWC0 < GetLocal
    def initialize(name, index)
      super(name, index, 0)
    end

    private

    def instruction_name
      "getlocal_WC_0"
    end
  end
end
