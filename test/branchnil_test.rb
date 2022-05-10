# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class BranchNilTest < TestCase
    def test_branchnil_jumps_if_nil
      source_code = "x = nil; if x&.to_s; puts 'hi'; end"
      assert_insns(
        [
          PutNil,
          SetLocalWC0,
          GetLocalWC0,
          Dup,
          BranchNil,
          OptSendWithoutBlock,
          BranchUnless,
          PutSelf,
          PutString,
          OptSendWithoutBlock,
          Leave,
          PutNil,
          Leave
        ],
        source_code
      )
      assert_stdout("", source_code)
    end

    def test_branchnil_doesnt_jump_if_not_nil
      source_code = "x = true; puts x&.to_s"
      assert_insns(
        [
          PutObject,
          SetLocalWC0,
          PutSelf,
          GetLocalWC0,
          Dup,
          BranchNil,
          OptSendWithoutBlock,
          OptSendWithoutBlock,
          Leave
        ],
        source_code
      )
      assert_stdout("true\n", source_code)
    end
  end
end
