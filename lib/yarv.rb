# frozen_string_literal: true

require "stringio"
require "set"
require "syntax_tree"

require_relative "yarv/call_data"
require_relative "yarv/execution_context"
require_relative "yarv/frame"
require_relative "yarv/insn/insn.rb"
require_relative "yarv/instruction_sequence"
require_relative "yarv/cfg"
require_relative "yarv/main"
require_relative "yarv/visitor"

# Require all of the files nested under the lib/yarv/insn directory.
Dir[File.expand_path("yarv/insn/*.rb", __dir__)].each do |filepath|
  require_relative "yarv/insn/#{File.basename(filepath, ".rb")}"
end

# The YARV module is a Ruby runtime that evlauates YARV instructions.
module YARV
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
    coverage_enabled: false,
    debug_frozen_string_literal: false,
    frozen_string_literal: false,
    inline_const_cache: true,
    instructions_unification: true,
    operands_unification: true,
    peephole_optimization: true,
    specialized_instruction: true,
    stack_caching: true,
    tailcall_optimization: false,
    trace_instruction: false
  )
    iseq =
      RubyVM::InstructionSequence.compile(
        source,
        file,
        path,
        lineno,
        coverage_enabled:,
        debug_frozen_string_literal:,
        frozen_string_literal:,
        inline_const_cache:,
        instructions_unification:,
        operands_unification:,
        peephole_optimization:,
        specialized_instruction:,
        stack_caching:,
        tailcall_optimization:,
        trace_instruction:
      )

    InstructionSequence.compile(Main.new, iseq.to_a)
  end
end
