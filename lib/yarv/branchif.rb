# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `branchif` has one argument: the jump index. It pops one value off the stack:
  # the jump condition.
  #
  # If the value popped off the stack is true, `branchif` jumps to
  # the jump index and continues executing there.
  #
  # ### TracePoint
  #
  # `branchif` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # x = true; x ||= 'foo' ; puts x
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,30)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] x@0
  # # 0000 putobject                              true                      (   1)[Li]
  # # 0002 setlocal_WC_0                          x@0
  # # 0004 getlocal_WC_0                          x@0
  # # 0006 dup
  # # 0007 branchif                               15
  # # 0009 pop
  # # 0010 putstring                              "foo"
  # # 0012 dup
  # # 0013 setlocal_WC_0                          x@0
  # # 0015 pop
  # # 0016 putself
  # # 0017 getlocal_WC_0                          x@0
  # # 0019 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # # 0021 leave
  # ~~~
  #
  class BranchIf
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def call(context)
      condition = context.stack.pop

      if condition
        jump_index = context.current_iseq.labels[label]
        context.program_counter = jump_index
      end
    end

    def pretty_print(q)
      q.text("branchif #{label.inspect}")
    end
  end
end
