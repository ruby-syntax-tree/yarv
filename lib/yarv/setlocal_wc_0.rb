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
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,9)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] value@0
  # # 0000 putobject                              5                         (   1)[Li]
  # # 0002 dup
  # # 0003 setlocal_WC_0                          value@0
  # # 0005 leave
  # ~~~
  #
  class SetLocalWC0 < SetLocal
    def initialize(name, index)
      super(name, index, 0)
    end

    private

    def instruction_name
      "setlocal_WC_0"
    end
  end
end
