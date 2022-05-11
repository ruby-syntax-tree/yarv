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
  # value = 2
  # Proc.new do
  #   value = 5
  # end
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,33)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] value@0
  # # 0000 putobject                              2                         (   1)[Li]
  # # 0001 setlocal_WC_0                          value@0
  # # 0003 opt_getinlinecache                     12, <is:0>
  # # 0006 putobject                              true
  # # 0008 getconstant                            :Proc
  # # 0010 opt_setinlinecache                     <is:0>
  # # 0012 send                                   <calldata!mid:new, argc:0>, block in <main>
  # # 0015 leave
  # #
  # # == disasm: #<ISeq:block in <main>@-e:1 (1,20)-(1,33)> (catch: FALSE)
  # # 0000 putobject                              5                         (   1)[LiBc]
  # # 0002 dup
  # # 0003 setlocal_WC_1                          value@0
  # # 0005 leave                                  [Br]
  # ~~~
  #
  class SetLocalWC1 < SetLocal
    def initialize(name, index)
      super(name, index, 0)
    end

    private

    def instruction_name
      "setlocal_WC_1"
    end
  end
end
