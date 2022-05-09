# frozen_string_literal: true

require_relative "yarv/branchunless"
require_relative "yarv/definemethod"
require_relative "yarv/dup"
require_relative "yarv/getconstant"
require_relative "yarv/getglobal"
require_relative "yarv/leave"
require_relative "yarv/opt_and"
require_relative "yarv/opt_aref"
require_relative "yarv/opt_div"
require_relative "yarv/opt_empty_p"
require_relative "yarv/opt_nil_p"
require_relative "yarv/opt_getinlinecache"
require_relative "yarv/opt_minus"
require_relative "yarv/opt_or"
require_relative "yarv/opt_plus"
require_relative "yarv/opt_send_without_block"
require_relative "yarv/opt_setinlinecache"
require_relative "yarv/opt_str_uminus"
require_relative "yarv/pop"
require_relative "yarv/putobject"
require_relative "yarv/putobject_int2fix_0"
require_relative "yarv/putself"
require_relative "yarv/putstring"
require_relative "yarv/setglobal"

module YARV
  # This is the self object at the top of the script.
  class Main
    def inspect
      "main"
    end
  end

  # This is the object that gets passed around all of the instructions as they
  # are being executed.
  class ExecutionContext
    # This represents an execution frame.
    class Frame
      attr_reader :iseq

      def initialize(iseq)
        @iseq = iseq
      end
    end

    # The system stack that tracks values through the execution of the program.
    attr_reader :stack

    # The global variables accessible to the program. These mirror the runtime
    # global variables if they have not been overridden.
    attr_reader :globals

    # The set of methods defined at runtime.
    attr_reader :methods

    # This is a stack of frames as they are being executed.
    attr_accessor :frames

    # The program counter used to determine which instruction to execute next.
    # This is an attr_accessor because it can be modified by instructions being
    # executed.
    attr_accessor :program_counter

    def initialize
      @stack = []
      @globals = {}
      @methods = {}
      @frames = []
      @program_counter = 0
    end

    # Calls a method on the given receiver. This is our method dispatch logic.
    # First, it looks to see if there is a method defined on the receiver's
    # class that we defined explicitly in our runtime. If there is, then it's
    # going to save the necessary information and invoke it. Otherwise, it's
    # going to call into the parent runtime and let it handle the method call.
    def call_method(receiver, name, arguments)
      if methods.key?([receiver.class, name])
        methods[[receiver.class, name]].emulate(self)
        stack.last
      else
        receiver.send(name, *arguments)
      end
    end

    # This returns the instruction sequence object that is currently being
    # executed. In other words, the instruction sequence that is at the top of
    # the frame stack.
    def current_iseq
      frames.last.iseq
    end

    # Defines a method on the given object's class keyed by the given name. The
    # iseq is an instance of the InstructionSequence class.
    def define_method(object, name, iseq)
      methods[[object.class, name]] = iseq
    end

    # This executes the given instruction sequence within a new execution frame.
    def with_frame(iseq)
      current_program_counter = program_counter
      current_stack_length = stack.length
      frames.push(Frame.new(iseq))

      begin
        yield
      ensure
        frames.pop
        @program_counter = current_program_counter
        @stack = @stack[0..current_stack_length]
      end
    end
  end

  # This object represents a set of instructions that will be executed.
  class InstructionSequence
    attr_reader :selfo, :insns, :labels

    def initialize(selfo, iseq)
      @selfo = selfo
      @insns = []
      @labels = {}

      iseq.last.each do |insn|
        case insn
        in Integer | :RUBY_EVENT_LINE
          # skip for now
        in Symbol
          @labels[insn] = @insns.length
        in [:branchunless, value]
          @insns << BranchUnless.new(value)
        in [:definemethod, name, iseq]
          @insns << DefineMethod.new(name, InstructionSequence.new(selfo, iseq))
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
        in [:opt_empty_p, { mid: :empty?, orig_argc: 0 }]
          @insns << OptEmptyP.new
        in [:opt_nil_p, { mid: :nil?, flag:, orig_argc: 0 }]
          @insns << OptNilP.new
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
        in [:putnil]
          # skip for now
        in [:putobject, object]
          @insns << PutObject.new(object)
        in [:putobject_INT2FIX_0_]
          @insns << PutObjectInt2Fix0.new
        in [:putself]
          @insns << PutSelf.new(selfo)
        in [:putstring, string]
          @insns << PutString.new(string)
        in [:setglobal, name]
          @insns << SetGlobal.new(name)
        end
      end
    end

    # Pushes a new frame onto the stack, executes the instructions contained
    # within this instruction sequence, then pops the frame off the stack.
    def emulate(context = ExecutionContext.new)
      context.with_frame(self) do
        context.program_counter = 0

        loop do
          insn = insns[context.program_counter]
          context.program_counter += 1

          insn.call(context)
          break if insn in Leave
        end
      end
    end
  end

  def self.compile(source, filename: nil)
    iseq =
      RubyVM::InstructionSequence.compile(
        source,
        filename,
        inline_const_cache: true,
        peephole_optimization: true,
        specialized_instruction: true,
        tailcall_optimization: false,
        trace_instruction: false
      )

    InstructionSequence.new(Main.new, iseq.to_a)
  end

  def self.emulate(source)
    context = ExecutionContext.new
    compile(source).emulate(context)
  end
end
