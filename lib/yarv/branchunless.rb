# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `branchunless` has one argument, the jump index
  # and pops one value off the stack, the jump condition.
  #
  # If the value popped off the stack is false,
  # `branchunless` jumps to the jump index and continues executing there.
  #
  # ### TracePoint
  #
  # `branchunless` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # if 2+3; puts 'foo'; end
  #
  # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,22)> (catch: FALSE)
  # 0000 putobject                              2                         (   1)[Li]
  # 0002 putobject                              3
  # 0004 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr]
  # 0006 branchunless                           14
  # 0008 putself
  # 0009 putstring                              "hi"
  # 0011 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # 0013 leave
  # 0014 putnil
  # 0015 leave
  # ~~~
  #
  class BranchUnless
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def call(context)
      condition = context.stack.pop

      unless condition
        jump_index = context.current_iseq.labels[label]
        context.program_counter = jump_index
      end
    end

    def pretty_print(q)
      q.text("branchunless #{label.inspect}")
    end
  end
end
