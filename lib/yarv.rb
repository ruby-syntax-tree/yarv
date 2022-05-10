# frozen_string_literal: true

# Require all of the files nested under the lib/yarv directory.
Dir[File.expand_path("yarv/*.rb", __dir__)].each do |filepath|
  require_relative "yarv/#{File.basename(filepath, ".rb")}"
end

# The YARV module is a Ruby runtime that evlauates YARV instructions.
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
      UNDEFINED = Object.new

      attr_reader :iseq, :locals

      def initialize(iseq)
        @iseq = iseq
        @locals = Array.new(iseq.locals.length, UNDEFINED)
      end

      # Fetches the value of a local variable from the frame. If the value has
      # not yet been initialized, it will raise an error.
      def get_local(index)
        local = locals[index - 3]
        if local == UNDEFINED
          raise NameError,
                "undefined local variable or method `#{local}' for #{iseq.selfo}"
        end

        local
      end

      # Sets the value of the local variable on the frame.
      def set_local(index, value)
        @locals[index - 3] = value
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
        methods[[receiver.class, name]].eval(self)
        stack.last
      else
        receiver.send(name, *arguments)
      end
    end

    # This returns the current execution frame.
    def current_frame
      frames.last
    end

    # This returns the instruction sequence object that is currently being
    # executed. In other words, the instruction sequence that is at the top of
    # the frame stack.
    def current_iseq
      current_frame.iseq
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

    # These are the names of the locals in the instruction sequence.
    attr_reader :locals

    def initialize(selfo, iseq)
      @selfo = selfo
      @insns = []
      @labels = {}

      @locals = iseq[10]

      iseq.last.each do |insn|
        case insn
        in Integer | :RUBY_EVENT_LINE
          # skip for now
        in Symbol
          @labels[insn] = @insns.length
        in :branchunless, value
          @insns << BranchUnless.new(value)
        in :definemethod, name, iseq
          @insns << DefineMethod.new(name, InstructionSequence.new(selfo, iseq))
        in [:dup]
          @insns << Dup.new
        in :duparray, array
          @insns << DupArray.new(array)
        in :getconstant, name
          @insns << GetConstant.new(name)
        in :getglobal, value
          @insns << GetGlobal.new(value)
        in :getlocal_WC_0, index
          @insns << GetLocalWC0.new(locals[index - 3], index)
        in [:leave]
          @insns << Leave.new
        in :newarray, size
          @insns << NewArray.new(size)
        in :newhash, size
          @insns << NewHash.new(size)
        in :opt_and, { mid: :&, orig_argc: 1 }
          @insns << OptAnd.new
        in :opt_aref, { mid: :[], orig_argc: 1 }
          @insns << OptAref.new
        in :opt_div, { mid: :/, orig_argc: 1 }
          @insns << OptDiv.new
        in :opt_empty_p, { mid: :empty?, orig_argc: 0 }
          @insns << OptEmptyP.new
        in :opt_eq, { mid: :==, orig_argc: 1 }
          @insns << OptEq.new
        in :opt_nil_p, { mid: :nil?, orig_argc: 0 }
          @insns << OptNilP.new
        in :opt_getinlinecache, label, cache
          @insns << OptGetInlineCache.new(label, cache)
        in :opt_length, { mid: :length, orig_argc: 0 }
          @insns << OptLength.new
        in :opt_minus, { mid: :-, orig_argc: 1 }
          @insns << OptMinus.new
        in :opt_mod, { mid: :%, orig_argc: 1 }
          @insns << OptMod.new
        in :opt_not, { mid: :!, orig_argc: 0 }
          @insns << OptNot.new
        in :opt_or, { mid: :|, orig_argc: 1 }
          @insns << OptOr.new
        in :opt_plus, { mid: :+, orig_argc: 1 }
          @insns << OptPlus.new
        in :opt_send_without_block, { mid:, orig_argc: }
          @insns << OptSendWithoutBlock.new(mid, orig_argc)
        in :opt_setinlinecache, cache
          @insns << OptSetInlineCache.new(cache)
        in :opt_str_uminus, value, { mid: :-@, orig_argc: 0 }
          @insns << OptStrUMinus.new(value)
        in :opt_succ, { mid: :succ, orig_argc: 0 }
          @insns << OptSucc.new
        in [:pop]
          @insns << Pop.new
        in [:putnil]
          @insns << PutNil.new
        in :putobject, object
          @insns << PutObject.new(object)
        in [:putobject_INT2FIX_0_]
          @insns << PutObjectInt2Fix0.new
        in [:putobject_INT2FIX_1_]
          @insns << PutObjectInt2Fix1.new
        in [:putself]
          @insns << PutSelf.new(selfo)
        in :putstring, string
          @insns << PutString.new(string)
        in :setglobal, name
          @insns << SetGlobal.new(name)
        in :setlocal_WC_0, index
          @insns << SetLocalWC0.new(locals[index - 3], index)
        end
      end
    end

    # Pushes a new frame onto the stack, executes the instructions contained
    # within this instruction sequence, then pops the frame off the stack.
    def eval(context = ExecutionContext.new)
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

  # This is the main entry into the project. It accepts a Ruby string that
  # represents source code. You can optionally also pass all of the same
  # arguments as you would to RubyVM::InstructionSequence.compile.
  #
  # It compiles the source into an InstructionSequence object. You can then
  # execute it
  def self.compile(
    source,
    file = "<compiled>",
    path = "<compiled>",
    lineno = 1,
    inline_const_cache: true,
    peephole_optimization: true,
    specialized_instruction: true,
    tailcall_optimization: false,
    trace_instruction: false
  )
    iseq =
      RubyVM::InstructionSequence.compile(
        source,
        file,
        path,
        lineno,
        inline_const_cache: inline_const_cache,
        peephole_optimization: peephole_optimization,
        specialized_instruction: specialized_instruction,
        tailcall_optimization: tailcall_optimization,
        trace_instruction: trace_instruction
      )

    InstructionSequence.new(Main.new, iseq.to_a)
  end
end
