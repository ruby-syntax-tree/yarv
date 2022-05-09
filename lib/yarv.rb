# frozen_string_literal: true

require_relative "yarv/dup"
require_relative "yarv/getconstant"
require_relative "yarv/getglobal"
require_relative "yarv/leave"
require_relative "yarv/opt_and"
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
    attr_accessor :program_counter

    def initialize
      @stack = []
      @globals = {}
      @program_counter = 0
    end
  end

  class InstructionSequence
    attr_reader :selfo, :insns

    def initialize(selfo, insns)
      @selfo = selfo
      @insns =
        insns.filter_map do |insn|
          case insn
          in Integer | :RUBY_EVENT_LINE
            # skip for now
          in Symbol
            # skip for now, these are labels
          in [:dup]
            Dup.new
          in [:getconstant, name]
            GetConstant.new(name)
          in [:getglobal, value]
            GetGlobal.new(value)
          in [:leave]
            Leave.new
          in [:opt_and, { mid: :&, orig_argc: 1 }]
            OptAnd.new
          in [:opt_div, { mid: :/, orig_argc: 1 }]
            OptDiv.new
          in [:opt_empty_p, {mid: :empty?, flag:, orig_argc: 0}]
            OptEmptyP.new
          in [:opt_getinlinecache, label, cache]
            OptGetInlineCache.new(label, cache)
          in [:opt_minus, { mid: :-, orig_argc: 1 }]
            OptMinus.new
          in [:opt_or, { mid: :|, orig_argc: 1 }]
            OptOr.new
          in [:opt_plus, { mid: :+,  orig_argc: 1 }]
            OptPlus.new
          in [:opt_send_without_block, { mid:, orig_argc: }]
            OptSendWithoutBlock.new(mid, orig_argc)
          in [:opt_setinlinecache, cache]
            OptSetInlineCache.new(cache)
          in [:opt_str_uminus, value, { mid: :-@, orig_argc: 0 }]
            OptStrUMinus.new(value)
          in [:pop]
            Pop.new
          in [:putobject, object]
            PutObject.new(object)
          in [:putself]
            PutSelf.new(selfo)
          in [:putstring, string]
            PutString.new(string)
          in [:setglobal, name]
            SetGlobal.new(name)
          end
        end
    end

    def emulate
      context = ExecutionContext.new
      insns.each do |insn|
        insn.execute(context)
        context.program_counter += 1
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
