# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `invokeblock` 
  #
  # ### TracePoint
  #
  # `invoke` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # def x; return yield self; end;
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,29)> (catch: FALSE)
  # # 0000 definemethod                           :x, x                     (   1)[Li]
  # # 0003 putobject                              :x
  # # 0005 leave
  # 
  # # == disasm: #<ISeq:x@<compiled>:1 (1,0)-(1,28)> (catch: FALSE)
  # # 0000 putself                                                          (   1)[LiCa]
  # # 0001 invokeblock                            <calldata!argc:1, ARGS_SIMPLE>
  # # 0003 leave                                  [Re]
  # ~~~
  #
  class InvokeBlock
    attr_reader :mid, :argc

    def initialize(mid, argc)
      @mid = mid
      @argc = argc
    end

    def call(context)
      # receiver, *arguments = context.stack.pop(argc + 1)
      # context.stack.push(context.call_method(receiver, mid, arguments))
    end

    def pretty_print(q)
      # q.text(
      #   "just checking"
      # )
    end
  end
end
