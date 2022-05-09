# frozen_string_literal: true

require_relative "yarv/branchunless"
require_relative "yarv/dup"
require_relative "yarv/getconstant"
require_relative "yarv/getglobal"
require_relative "yarv/leave"
require_relative "yarv/opt_and"
require_relative "yarv/opt_aref"
require_relative "yarv/opt_div"
require_relative "yarv/opt_empty_p"
require_relative "yarv/opt_getinlinecache"
require_relative "yarv/opt_minus"
require_relative "yarv/opt_or"
require_relative "yarv/opt_plus"
require_relative "yarv/opt_send_without_block"
require_relative "yarv/opt_setinlinecache"
require_relative "yarv/opt_str_uminus"
require_relative "yarv/pop"
require_relative "yarv/putobject"
require_relative "yarv/putself"
require_relative "yarv/putstring"
require_relative "yarv/setglobal"

module YARV
  class Main
    def inspect
      "main"
    end
  end

  class ExecutionContext
    attr_reader :stack
    attr_reader :globals
    attr_accessor :program_counter, :iseq

    def initialize
      @stack = []
      @globals = {}
      @program_counter = 0
      @iseq = nil
    end
  end

  class InstructionSequence
    attr_reader :selfo, :insns, :labels

    def initialize(selfo, insns)
      @selfo = selfo
      @insns = []
      @labels = {}
      insns.each do |insn|
        case insn
        in Integer | :RUBY_EVENT_LINE
          # skip for now
        in Symbol
          @labels[insn] = @insns.length
        in [:branchunless, value]
          @insns << BranchUnless.new(value)
        in [:dup]
          @insns << Dup.new
        in [:getconstant, name]
          @insns << GetConstant.new(name)
        in [:getglobal, value]
          @insns << GetGlobal.new(value)
        in [:leave]
          @insns << Leave.new
        in [:opt_and, { mid: :&, orig_argc: 1 }]
          @insns << OptAnd.new
        in [:opt_aref, { mid: :[], orig_argc: 1 }]
          @insns << OptAref.new
        in [:opt_div, { mid: :/, orig_argc: 1 }]
          @insns << OptDiv.new
        in [:opt_empty_p, {mid: :empty?, flag:, orig_argc: 0}]
          @insns << OptEmptyP.new
        in [:opt_getinlinecache, label, cache]
          @insns << OptGetInlineCache.new(label, cache)
        in [:opt_minus, { mid: :-, orig_argc: 1 }]
          @insns << OptMinus.new
        in [:opt_or, { mid: :|, orig_argc: 1 }]
          @insns << OptOr.new
        in [:opt_plus, { mid: :+,  orig_argc: 1 }]
          @insns << OptPlus.new
        in [:opt_send_without_block, { mid:, orig_argc: }]
          @insns << OptSendWithoutBlock.new(mid, orig_argc)
        in [:opt_setinlinecache, cache]
          @insns << OptSetInlineCache.new(cache)
        in [:opt_str_uminus, value, { mid: :-@, orig_argc: 0 }]
          @insns << OptStrUMinus.new(value)
        in [:pop]
          @insns << Pop.new
        in [:putobject, object]
          @insns << PutObject.new(object)
        in [:putself]
          @insns << PutSelf.new(selfo)
        in [:putstring, string]
          @insns << PutString.new(string)
        in [:setglobal, name]
          @insns << SetGlobal.new(name)
        in [:putnil]
          # skip for now
        end
      end
    end

    def emulate
      context = ExecutionContext.new
      context.iseq = self
      while true
        insn = insns[context.program_counter]
        context.program_counter += 1
        insn.execute(context)

        break if insn in Leave
      end
    end
  end

  def self.compile(source)
    iseq = RubyVM::InstructionSequence.compile(source, specialized_instruction: true)
    InstructionSequence.new(Main.new, iseq.to_a.last)
  end

  def self.emulate(source)
    compile(source).emulate
  end
end
