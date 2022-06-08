# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `invokeblock` invokes the block passed to a method during a yield.
  #
  # ### TracePoint
  #
  #
  # ### Usage
  #
  # ~~~ruby
  # def foo; yield; end
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,19)> (catch: FALSE)
  # # 0000 definemethod                           :foo, foo                 (   1)[Li]
  # # 0003 putobject                              :foo
  # # 0005 leave
  # #
  # # == disasm: #<ISeq:foo@-e:1 (1,0)-(1,19)> (catch: FALSE)
  # # 0000 invokeblock                            <calldata!argc:0, ARGS_SIMPLE>(   1)[LiCa]
  # # 0002 leave                                  [Re]
  # # ~~~
  #
  class InvokeBlock < Instruction
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in InvokeBlock[call_data: ^(call_data)]
    end

    def call(context)
      *arguments = context.stack.pop(call_data.argc)
      result = context.current_frame.execute_block(*arguments)

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { call_data: }
    end

    def disasm(iseq)
      "%-38s %s" % ["invokeblock", call_data]
    end
  end
end
