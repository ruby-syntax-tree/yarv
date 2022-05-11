# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `branchnil` has one argument: the jump index. It pops one value off the stack:
  # the jump condition.
  #
  # If the value popped off the stack is nil, `branchnil` jumps to
  # the jump index and continues executing there.
  #
  # ### TracePoint
  #
  # There is no trace point for `branchnil`.
  #
  # ### Usage
  #
  # ~~~ruby
  # x = nil
  # if x&.to_s
  #   puts "hi"
  # end
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,35)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] x@0
  # # 0000 putnil                                                           (   1)[Li]
  # # 0001 setlocal_WC_0                          x@0
  # # 0003 getlocal_WC_0                          x@0
  # # 0005 dup
  # # 0006 branchnil                              10
  # # 0008 opt_send_without_block                 <calldata!mid:to_s, argc:0, ARGS_SIMPLE>
  # # 0010 branchunless                           18
  # # 0012 putself
  # # 0013 putstring                              "hi"
  # # 0015 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # # 0017 leave
  # # 0018 putnil
  # # 0019 leave
  # ~~~
  #
  class BranchNil
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def call(context)
      condition = context.stack.pop

      if condition.nil?
        jump_index = context.current_iseq.labels[label]
        context.program_counter = jump_index
      end
    end

    def to_s
      "%-38s %s" % ["branchnil", label["label_".length..]]
    end
  end
end
