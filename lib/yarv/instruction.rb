# frozen_string_literal: true

module YARV
  # Abstract base instruction.
  class Instruction
    # Whether or not this instruction is a branch instruction.
    def branches?
      false
    end

    # Whether or not this instruction leaves the current frame.
    def leaves?
      false
    end

    # Whether or not this instruction falls through to the next instruction if
    # its branching fails.
    def falls_through?
      false
    end

    # A hook method to be called when the instruction is being disassembled. The
    # child classes will have their respective InstructionSequence passed in.
    def to_s
      disasm(nil)
    end
  end
end
