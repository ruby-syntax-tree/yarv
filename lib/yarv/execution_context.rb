# frozen_string_literal: true

module YARV
  # This is the object that gets passed around all of the instructions as they
  # are being executed.
  class ExecutionContext
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
      # Steal the LOAD_PATHS from the host but not LOADED_FEATURES
      @globals = { :$: => $:, :"$\"" => [] }
      @methods = {}
      @frames = []
      @program_counter = 0
    end

    # Calls a method on the given receiver. This is our method dispatch logic.
    # First, it looks to see if there is a method defined on the receiver's
    # class that we defined explicitly in our runtime. If there is, then it's
    # going to save the necessary information and invoke it. Otherwise, it's
    # going to call into the parent runtime and let it handle the method call.
    #
    # Note that the array of arguments coming in here is necessarily the same
    # values that align with the parameters to the method being called. They are
    # simply the popped values off the top of the stack. It is the
    # responsibility of this method to ensure that they get copied into the
    # locals table in the correct order.
    def call_method(call_data, receiver, arguments, &block)
      if (method = methods[[receiver.class, call_data.mid]])
        # TODO: handle InvokeBlock

        # We only support a subset of the valid argument permutations. This
        # validates each kind to make sure we don't accidentally try to handle a
        # method that we currently don't support.
        case method.args
        in {}
          # No arguments, we're good
        in { lead_num: ^(arguments.length), **nil }
          # Only leading arguments and we line up with the expected number
        end

        eval(method) do
          # Inside this block, we have already pushed the frame. So now we need
          # to establish the correct local variables.
          arguments.each_with_index do |argument, index|
            current_frame.locals[index] = argument
          end
        end

        stack.last
      elsif receiver.is_a?(Main) && call_data.mid == :require
        receiver.send(call_data.mid, self, *arguments)
      else
        receiver.send(call_data.mid, *arguments, &block)
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
      @program_counter = 0

      begin
        yield
      ensure
        frames.pop
        @program_counter = current_program_counter
        @stack = @stack[0..current_stack_length]
      end
    end

    # Pushes a new frame onto the stack, executes the instructions contained
    # within this instruction sequence, then pops the frame off the stack.
    def eval(iseq)
      with_frame(iseq) do
        yield if block_given?

        loop do
          insn = iseq.insns[program_counter]
          self.program_counter += 1

          insn.call(self)
          break if insn in Leave
        end
      end
    end
  end
end
