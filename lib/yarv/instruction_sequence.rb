# frozen_string_literal: true

module YARV
  # This object represents a set of instructions that will be executed.
  class InstructionSequence
    attr_reader :selfo, :insns, :labels

    # This is the native instruction sequence that we are wrapping.
    attr_reader :iseq

    # This is the parent InstructionSequence object if there is one.
    attr_reader :parent

    # These handlers handle thrown exceptions.
    ThrowHandler =
      Struct.new(:type, :iseq, :begin_label, :end_label, :exit_label)

    attr_reader :throw_handlers

    def initialize(selfo, iseq, parent = nil)
      @selfo = selfo
      @iseq = iseq[...-1]
      @parent = parent

      @insns = []
      @labels = {}

      @throw_handlers =
        (catch_table || []).map do |handler|
          type, child_iseq, begin_label, end_label, exit_label, = handler
          throw_iseq =
            InstructionSequence.compile(selfo, child_iseq, self) if child_iseq

          ThrowHandler.new(type, throw_iseq, begin_label, end_label, exit_label)
        end
    end

    class UnimplementedInstruction
      attr_reader :name, :args

      def initialize(name, *args)
        @name = name
        @args = args
      end

      def ==(other)
        other in UnimplementedInstruction[name: ^(name), args: ^(args)]
      end

      def call(context)
        raise NotImplementedError, "Unimplemented instruction: #{name}"
      end

      def deconstruct_keys(keys)
        { name:, args: }
      end

      def to_s
        name.to_s
      end
    end

    def self.compile(selfo, iseq, parent = nil)
      iseq
        .last
        .each_with_object(new(selfo, iseq, parent)) do |insn, compiled|
          case insn
          in Integer | :RUBY_EVENT_LINE
            # skip for now
          in Symbol
            compiled.labels[insn] = compiled.insns.length
          in :adjuststack, size
            compiled << AdjustStack.new(size)
          in [:anytostring]
            compiled << AnyToString.new
          in :branchif, value
            compiled << BranchIf.new(value)
          in :branchnil, value
            compiled << BranchNil.new(value)
          in :branchunless, value
            compiled << BranchUnless.new(value)
          in :checkkeyword, bits_index, index
            compiled << UnimplementedInstruction.new(
              "checkkeyword",
              bits_index,
              index
            )
          in :checkmatch, type
            compiled << UnimplementedInstruction.new("checkmatch", type)
          in :checktype, type
            compiled << UnimplementedInstruction.new("checktype", type)
          in [:concatarray]
            compiled << ConcatArray.new
          in :concatstrings, num
            compiled << ConcatStrings.new(num)
          in :defineclass, name, iseq, flags
            compiled << UnimplementedInstruction.new(
              "defineclass",
              name,
              compile(selfo, iseq, compiled),
              flags
            )
          in :defined, type, object, value
            compiled << Defined.new(type, object, value)
          in :definemethod, name, iseq
            compiled << DefineMethod.new(name, compile(selfo, iseq, compiled))
          in :definesmethod, name, iseq
            compiled << UnimplementedInstruction.new(
              "definesmethod",
              name,
              compile(selfo, iseq, compiled)
            )
          in [:dup]
            compiled << Dup.new
          in :duparray, array
            compiled << DupArray.new(array)
          in :duphash, hash
            compiled << DupHash.new(hash)
          in :dupn, offset
            compiled << DupN.new(offset)
          in :expandarray, size, flag
            compiled << UnimplementedInstruction.new("expandarray", size, flag)
          in :getblockparam, index, level
            compiled << UnimplementedInstruction.new(
              "getblockparam",
              index,
              level
            )
          in :getblockparamproxy, index, level
            compiled << UnimplementedInstruction.new(
              "getblockparamproxy",
              index,
              level
            )
          in :getclassvariable, name, cache
            compiled << UnimplementedInstruction.new(
              "getclassvariable",
              name,
              cache
            )
          in :getconstant, name
            compiled << GetConstant.new(name)
          in :getglobal, value
            compiled << GetGlobal.new(value)
          in :getinstancevariable, name, cache
            compiled << UnimplementedInstruction.new(
              "getinstancevariable",
              name,
              cache
            )
          in :getlocal, offset, level
            current = compiled
            level.times { current = current.parent }

            index = current.local_index(offset)
            compiled << GetLocal.new(current.locals[index], index, level)
          in :getlocal_WC_0, offset
            index = compiled.local_index(offset)
            compiled << GetLocalWC0.new(compiled.locals[index], index)
          in :getlocal_WC_1, offset
            index = parent.local_index(offset)
            compiled << GetLocalWC1.new(parent.locals[index], index)
          in :getspecial, key, type
            compiled << UnimplementedInstruction.new("getspecial", key, type)
          in [:intern]
            compiled << Intern.new
          in :invokeblock, { mid: nil, orig_argc:, flag: }
            compiled << InvokeBlock.new(CallData.new(nil, orig_argc, flag))
          in :invokesuper, { mid: nil, orig_argc:, flag: }, block_iseq
            block_iseq = compile(selfo, block_iseq, compiled) if block_iseq
            compiled << UnimplementedInstruction.new(
              "invokesuper",
              CallData.new(nil, orig_argc, flag),
              block_iseq
            )
          in :jump, value
            compiled << Jump.new(value)
          in [:leave]
            compiled << Leave.new
          in :newarray, size
            compiled << NewArray.new(size)
          in :newhash, size
            compiled << NewHash.new(size)
          in :newarraykwsplat, size
            compiled << UnimplementedInstruction.new("newarraykwsplat", size)
          in :newrange, exclude_end
            compiled << NewRange.new(exclude_end)
          in [:nop]
            compiled << Nop.new
          in :objtostring, { mid: :to_s, orig_argc: 0, flag: }
            compiled << ObjToString.new(CallData.new(:to_s, 0, flag))
          in :once, iseq, cache
            compiled << UnimplementedInstruction.new(
              "once",
              compile(selfo, iseq, compiled),
              cache
            )
          in :opt_and, { mid: :&, orig_argc: 1, flag: }
            compiled << OptAnd.new(CallData.new(:&, 1, flag))
          in :opt_aref, { mid: :[], orig_argc: 1, flag: }
            compiled << OptAref.new(CallData.new(:[], 1, flag))
          in :opt_aset, { mid: :[]=, orig_argc: 2, flag: }
            compiled << OptAset.new(CallData.new(:[]=, 2, flag))
          in :opt_aset_with, key, { mid: :[]=, orig_argc: 2, flag: }
            compiled << OptAsetWith.new(key, CallData.new(:[]=, 2, flag))
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
          in :opt_regexpmatch2, { mid: :=~, orig_argc: 1, flag: }
            compiled << OptRegexpMatch2.new(CallData.new(:=~, 1, flag))
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
          in :putspecialobject, type
            compiled << UnimplementedInstruction.new("putspecialobject", type)
          in :putstring, string
            compiled << PutString.new(string)
          in :send, { mid:, orig_argc:, flag: }, block_iseq
            block_iseq =
              compile(selfo, block_iseq, compiled) unless block_iseq.nil?

            compiled << Send.new(CallData.new(mid, orig_argc, flag), block_iseq)
          in :setblockparam, index, level
            compiled << UnimplementedInstruction.new(
              "setblockparam",
              index,
              level
            )
          in :setclassvariable, name, cache
            compiled << UnimplementedInstruction.new(
              "setclassvariable",
              name,
              cache
            )
          in :setconstant, name
            compiled << UnimplementedInstruction.new("setconstant", name)
          in :setglobal, name
            compiled << SetGlobal.new(name)
          in :setinstancevariable, name, cache
            compiled << UnimplementedInstruction.new(
              "setinstancevariable",
              name,
              cache
            )
          in :setlocal, offset, level
            current = compiled
            level.times { current = current.parent }

            index = current.local_index(offset)
            compiled << SetLocal.new(current.locals[index], index, level)
          in :setlocal_WC_0, offset
            index = compiled.local_index(offset)
            compiled << SetLocalWC0.new(compiled.locals[index], index)
          in :setlocal_WC_1, offset
            index = parent.local_index(offset)
            compiled << SetLocalWC1.new(parent.locals[index], index)
          in :setn, index
            compiled << SetN.new(index)
          in :setspecial, key
            compiled << UnimplementedInstruction.new("setspecial", key)
          in :splatarray, flag
            compiled << UnimplementedInstruction.new("splatarray", flag)
          in [:swap]
            compiled << Swap.new
          in :throw, type
            compiled << UnimplementedInstruction.new("throw", type)
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

    def child_iseqs
      child_iseqs = []
      insns.each do |insn|
        case insn
        when DefineMethod
          child_iseqs << insn.iseq
        when Send
          child_iseqs << insn.block_iseq if insn.block_iseq
        end
      end
      child_iseqs
    end

    def all_iseqs
      [self] + child_iseqs.flat_map(&:all_iseqs)
    end

    # Print out this instruction sequence to the given output stream.
    def disasm(output = StringIO.new, prefix = "")
      output.print("#{prefix}#{disasm_header("disasm")} ")
      handled = []

      if throw_handlers.any?
        output.puts("(catch: TRUE)")
        output.puts("#{prefix}== catch table")

        throw_handlers.each do |handler|
          output.puts("#{prefix}| catch type: #{handler.type}")

          if handler.iseq
            handler.iseq.disasm(output, "#{prefix}| ")
            handled << handler.iseq
          end
        end

        output.puts("#{prefix}|#{"-" * 72}")
      else
        output.puts("(catch: FALSE)")
      end

      insns.each_with_index do |insn, insn_pc|
        output.puts(prefix + disasm_insn(insn, insn_pc))
      end

      child_iseqs.each do |child_iseq|
        output.puts
        child_iseq.disasm(output, prefix)
      end

      output.string
    end

    def disasm_header(tag)
      "== #{tag} #<ISeq:#{name}>"
    end

    def disasm_insn(insn, insn_pc)
      "#{insn_pc.to_s.rjust(4, "0")} #{insn.disasm(self)}"
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

    # These are the various ways the instruction sequence handles raised
    # exceptions.
    def catch_table
      iseq[12]
    end

    def eval(context = ExecutionContext.new)
      context.eval(self)
    end
  end
end
