# frozen_string_literal: true

require "test_helper"

module YARV
  class DupNTest < TestCase
    def test_execute
      YARV.compile("Object::X ||= true").insns =>
        [OptGetInlineCache,
        PutObject,
        GetConstant,
        OptSetInlineCache,
        Dup,
        Defined,
        BranchUnless,
        Dup,
        PutObject,
        GetConstant,
        Dup,
        BranchIf,
        Pop,
        PutObject,
        DupN[offset: 2],
        Swap,
        InstructionSequence::UnimplementedInstruction[name: "setconstant"],
        Swap,
        Pop,
        Leave]
    end
  end
end
