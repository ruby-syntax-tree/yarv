# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_case_dispatch` is a branch instruction that moves the control flow for
  # case statements.
  #
  # It has two arguments: the cdhash and an else_offset index. It pops one value off
  # the stack: a hash key. `opt_case_dispatch` looks up the key in the cdhash
  # and jumps to the corresponding index value, if there is one.
  # If there is no value in the cdhash, `opt_case_dispatch` jumps to the else_offset index.
  #
  # The cdhash is a Ruby hash used for handling optimized `case` statements.
  # The keys are the conditions of `when` clauses in the `case` statement,
  # and the values are the labels to which to jump. This optimization can be
  # applied only when the keys can be directly compared.
  #
  # ### TracePoint
  #
  # There is no trace point for `opt_case_dispatch`.
  #
  # ### Usage
  #
  # ~~~ruby
  # case 1
  # when 1
  #   puts "foo"
  # else
  #   puts "bar"
  # end
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,49)> (catch: FALSE)
  # # 0000 putobject_INT2FIX_0_                                             (   1)[Li]
  # # 0001 dup
  # # 0002 opt_case_dispatch                      <cdhash>, 12
  # # 0005 putobject_INT2FIX_1_
  # # 0006 topn                                   1
  # # 0008 opt_send_without_block                 <calldata!mid:===, argc:1, FCALL|ARGS_SIMPLE>
  # # 0010 branchif                               19
  # # 0012 pop
  # # 0013 putself
  # # 0014 putstring                              "bar"
  # # 0016 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # # 0018 leave
  # # 0019 pop
  # # 0020 putself
  # # 0021 putstring                              "foo"
  # # 0023 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # # 0025 leave
  # ~~~
  #
  class OptCaseDispatch < Instruction
    attr_reader :cdhash, :else_offset

    def initialize(cdhash, else_offset)
      @cdhash = Hash[*cdhash]
      @else_offset = else_offset
    end

    def ==(other)
      other in OptCaseDispatch[cdhash: ^(cdhash), else_offset: ^(else_offset)]
    end

    def call(context)
      hash_key = context.stack.pop
      if (label = cdhash[hash_key])
        jump_index = context.current_iseq.labels[label]
        context.program_counter = jump_index
      else
        jump_index = context.current_iseq.labels[else_offset]
        context.program_counter = jump_index
      end
    end

    def deconstruct_keys(keys)
      { cdhash:, else_offset: }
    end

    def disasm(iseq)
      "%-38s %s %s" %
        ["opt_case_dispatch", "<cdhash>,", else_offset["label_".length..]]
    end
  end
end
