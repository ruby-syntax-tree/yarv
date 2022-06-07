# frozen_string_literal: true

module YARV
  # Abstract base instruction.
  class Insn
    def to_s
      disasm(nil)
    end
  end
end
