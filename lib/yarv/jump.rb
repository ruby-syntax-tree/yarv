# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `jump` has one argument, the jump index, which it uses to set the next
  # instruction to execute.
  #
  # ### TracePoint
  #
  # There is no trace point for `jump`.
  #
  # ### Usage
  #
  # ~~~ruby
  # y = 0
  # if y == 0
  #   puts "0"
  # else
  #   puts "2"
  # end
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,48)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] y@0
  # # 0000 putobject_INT2FIX_0_                                             (   1)[Li]
  # # 0001 setlocal_WC_0                          y@0
  # # 0003 getlocal_WC_0                          y@0
  # # 0005 putobject_INT2FIX_0_
  # # 0006 opt_eq                                 <calldata!mid:==, argc:1, ARGS_SIMPLE>[CcCr]
  # # 0008 branchunless                           20
  # # 0010 jump                                   12
  # # 0012 putself
  # # 0013 putstring                              "0"
  # # 0015 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # # 0017 jump                                   25
  # # 0019 pop
  # # 0020 putself
  # # 0021 putstring                              "2"
  # # 0023 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # # 0025 leave
  # ~~~
  #
  class Jump
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def call(context)
      jump_index = context.current_iseq.labels[label]
      context.program_counter = jump_index
    end

    def to_s
      "%-38s %s" % ["jump", label["label_".length..]]
    end
  end
end
