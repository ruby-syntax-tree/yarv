# frozen_string_literal: true

module YARV
  # This object represents a set of instructions that will be executed.
  class InstructionSequence
    attr_reader :selfo, :insns, :labels

    # This is the native instruction sequence that we are wrapping.
    attr_reader :iseq

    def initialize(selfo, iseq)
      @selfo = selfo
      @iseq = iseq

      @insns = []
      @labels = {}
    end

    def self.compile(selfo, iseq)
      iseq
        .last
        .each_with_object(new(selfo, iseq)) do |insn, compiled|
          case insn
          in Integer | :RUBY_EVENT_LINE
            # skip for now
          in Symbol
            compiled.labels[insn] = compiled.insns.length
          in [:anytostring]
            compiled << AnyToString.new
          in :branchif, value
            compiled << BranchIf.new(value)
          in :branchnil, value
            compiled << BranchNil.new(value)
          in :branchunless, value
            compiled << BranchUnless.new(value)
          in [:concatarray]
            compiled << ConcatArray.new
          in :concatstrings, num
            compiled << ConcatStrings.new(num)
          in :definemethod, name, iseq
            compiled << DefineMethod.new(name, compile(selfo, iseq))
          in [:dup]
            compiled << Dup.new
          in :duparray, array
            compiled << DupArray.new(array)
          in :duphash, hash
            compiled << DupHash.new(hash)
          in :getconstant, name
            compiled << GetConstant.new(name)
          in :getglobal, value
            compiled << GetGlobal.new(value)
          in :getlocal_WC_0, offset
            index = compiled.local_index(offset)
            compiled << GetLocalWC0.new(compiled.locals[index], index)
          in [:intern]
            compiled << Intern.new
          in :jump, value
            compiled << Jump.new(value)
          in [:leave]
            compiled << Leave.new
          in :newarray, size
            compiled << NewArray.new(size)
          in :newhash, size
            compiled << NewHash.new(size)
          in :newrange, exclude_end
            compiled << NewRange.new(exclude_end)
          in [:nop]
            compiled << Nop.new
          in :objtostring, { mid: :to_s, orig_argc: 0, flag: }
            compiled << ObjToString.new(CallData.new(:to_s, 0, flag))
          in :opt_and, { mid: :&, orig_argc: 1, flag: }
            compiled << OptAnd.new(CallData.new(:&, 1, flag))
          in :opt_aref, { mid: :[], orig_argc: 1, flag: }
            compiled << OptAref.new(CallData.new(:[], 1, flag))
          in :opt_aset, { mid: :[]=, orig_argc: 2 }
            compiled << OptAset.new(CallData.new(:[]=, 2, flag))
          in :opt_aref_with, key, { mid: :[], orig_argc: 1, flag: }
            compiled << OptArefWith.new(key, CallData.new(:[], 1, flag))
          in :opt_case_dispatch, cdhash, offset
            compiled << OptCaseDispatch.new(cdhash, offset)
          in :opt_div, { mid: :/, orig_argc: 1, flag: }
            compiled << OptDiv.new(CallData.new(:/, 1, flag))
          in :opt_empty_p, { mid: :empty?, orig_argc: 0, flag: }
            compiled << OptEmptyP.new(CallData.new(:empty?, 0, flag))
          in :opt_eq, { mid: :==, orig_argc: 1, flag: }
            compiled << OptEq.new(CallData.new(:==, 1, flag))
          in :opt_neq, eq_cd, neq_cd
            compiled << OptNeq.new(
              CallData.new(:==, 1, eq_cd.fetch(:flag)),
              CallData.new(:!=, 1, neq_cd.fetch(:flag))
            )
          in :opt_ge, { mid: :>=, orig_argc: 1, flag: }
            compiled << OptGe.new(CallData.new(:>=, 1, flag))
          in :opt_gt, { mid: :>, orig_argc: 1, flag: }
            compiled << OptGt.new(CallData.new(:>, 1, flag))
          in :opt_le, { mid: :<=, orig_argc: 1, flag: }
            compiled << OptLe.new(CallData.new(:<=, 1, flag))
          in :opt_lt, { mid: :<, orig_argc: 1, flag: }
            compiled << OptLt.new(CallData.new(:<, 1, flag))
          in :opt_ltlt, { mid: :<<, orig_argc: 1, flag: }
            compiled << OptLtLt.new(CallData.new(:<<, 1, flag))
          in :opt_nil_p, { mid: :nil?, orig_argc: 0, flag: }
            compiled << OptNilP.new(CallData.new(:nil?, 0, flag))
          in :opt_getinlinecache, label, cache
            compiled << OptGetInlineCache.new(label, cache)
          in :opt_length, { mid: :length, orig_argc: 0, flag: }
            compiled << OptLength.new(CallData.new(:length, 0, flag))
          in :opt_minus, { mid: :-, orig_argc: 1, flag: }
            compiled << OptMinus.new(CallData.new(:-, 1, flag))
          in :opt_mod, { mid: :%, orig_argc: 1, flag: }
            compiled << OptMod.new(CallData.new(:%, 1, flag))
          in :opt_mult, { mid: :*, orig_argc: 1, flag: }
            compiled << OptMult.new(CallData.new(:*, 1, flag))
          in :opt_newarray_max, size
            compiled << OptNewArrayMax.new(size)
          in :opt_newarray_min, size
            compiled << OptNewArrayMin.new(size)
          in :opt_not, { mid: :!, orig_argc: 0, flag: }
            compiled << OptNot.new(CallData.new(:!, 0, flag))
          in :opt_or, { mid: :|, orig_argc: 1, flag: }
            compiled << OptOr.new(CallData.new(:|, 1, flag))
          in :opt_plus, { mid: :+, orig_argc: 1, flag: }
            compiled << OptPlus.new(CallData.new(:+, 1, flag))
          in :opt_send_without_block, { mid:, orig_argc:, flag: }
            compiled << OptSendWithoutBlock.new(
              CallData.new(mid, orig_argc, flag)
            )
          in :opt_setinlinecache, cache
            compiled << OptSetInlineCache.new(cache)
          in :opt_size, { mid: :size, orig_argc: 0, flag: }
            compiled << OptSize.new(CallData.new(:size, 0, flag))
          in :opt_str_freeze, value, { mid: :freeze, orig_argc: 0, flag: }
            compiled << OptStrFreeze.new(value, CallData.new(:freeze, 0, flag))
          in :opt_str_uminus, value, { mid: :-@, orig_argc: 0, flag: }
            compiled << OptStrUMinus.new(value, CallData.new(:-@, 0, flag))
          in :opt_succ, { mid: :succ, orig_argc: 0, flag: }
            compiled << OptSucc.new(CallData.new(:succ, 0, flag))
          in [:pop]
            compiled << Pop.new
          in [:putnil]
            compiled << PutNil.new
          in :putobject, object
            compiled << PutObject.new(object)
          in [:putobject_INT2FIX_0_]
            compiled << PutObjectInt2Fix0.new
          in [:putobject_INT2FIX_1_]
            compiled << PutObjectInt2Fix1.new
          in [:putself]
            compiled << PutSelf.new(selfo)
          in :putstring, string
            compiled << PutString.new(string)
          in :send, { mid:, orig_argc:, flag: }, block_iseq
            block_iseq = compile(selfo, block_iseq) unless block_iseq.nil?
            compiled << Send.new(CallData.new(mid, orig_argc, flag), block_iseq)
          in :setglobal, name
            compiled << SetGlobal.new(name)
          in :setn, index
            compiled << SetN.new(index)
          in :setlocal_WC_0, offset
            index = compiled.local_index(offset)
            compiled << SetLocalWC0.new(compiled.locals[index], index)
          in [:swap]
            compiled << Swap.new
          in :topn, n
            compiled << TopN.new(n)
          in :toregexp, opts, cnt
            compiled << ToRegexp.new(opts, cnt)
          end
        end
    end

    def <<(insn)
      insns << insn
    end

    def ==(other)
      other in InstructionSequence[insns: ^(insns), labels: ^(labels.values)]
    end

    def deconstruct_keys(keys)
      { insns:, labels: labels.values }
    end

    # This is the name assigned to this instruction sequence.
    def name
      iseq[5]
    end

    # These are the names of the locals in the instruction sequence.
    def locals
      iseq[10]
    end

    # Indices that are given for getlocal and setlocal instructions are actually
    # how far back they are from the top of the stack. So here we do a little
    # math to make them a little easier to work with.
    def local_index(offset)
      (locals.length - (offset - 3)) - 1
    end

    # This is the information about the arguments that should be passed into
    # this instruction sequence.
    def args
      iseq[11]
    end

    def eval(context = ExecutionContext.new)
      context.eval(self)
    end
  end
end