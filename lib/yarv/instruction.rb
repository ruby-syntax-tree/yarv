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

    # How many values are read from the stack.
    def reads
      raise "not implemented #{self.class}"
    end

    # How many values are written to the stack.
    def writes
      raise "not implemented #{self.class}"
    end

    # Does the instruction have side effects? Control-flow counts as a
    # side-effect, as do some special-case instructions like Leave
    def side_effects?
      true
    end

    # A hook method to be called when the instruction is being disassembled. The
    # child classes will have their respective InstructionSequence passed in.
    def to_s
      disasm(nil)
    end
  end
end
