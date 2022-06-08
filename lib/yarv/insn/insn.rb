# frozen_string_literal: true

module YARV
  # Abstract base instruction.
  class Insn
    def branches?
      false
    end

    def leaves?
      false
    end

    def falls_through?
      false
    end

    def to_s
      disasm(nil)
    end
  end
end
