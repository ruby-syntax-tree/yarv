# frozen_string_literal: true
require_relative './getlocal'

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
  # Proc.new do
  #   value
  # end
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,29)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] value@0
  # # 0000 putobject                              5                         (   1)[Li]
  # # 0001 setlocal_WC_0                          value@0
  # # 0003 opt_getinlinecache                     12, <is:0>
  # # 0006 putobject                              true
  # # 0008 getconstant                            :Proc
  # # 0010 opt_setinlinecache                     <is:0>
  # # 0012 send                                   <calldata!mid:new, argc:0>, block in <main>
  # # 0015 leave
  # #
  # # == disasm: #<ISeq:block in <main>@-e:1 (1,20)-(1,29)> (catch: FALSE)
  # # 0000 getlocal_WC_1                          value@0                   (   1)[LiBc]
  # # 0002 leave                                  [Br]
  # ~~~
  #
  class GetLocalWC1 < GetLocal
    def initialize(name, index)
      super(name, index, 1)
    end

    private

    def instruction_name
      "getlocal_WC_1"
    end
  end
end
