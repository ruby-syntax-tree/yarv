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
    attr_reader :argc

    def initialize(argc)
      @argc = argc
    end

    def call(context)
      args = argc.times.map { pop }.reverse
      context.stack.push(context.current_frame.iseq.call(*args))
    end

    def pretty_print(q)
      q.text("invokeblock")
    end
  end
end
