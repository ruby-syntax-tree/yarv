# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class BranchUnlessTest < TestCase
    def test_branchunless_jumps_if_false
      source_code = "if 2+3; puts 'foo'; end"
      assert_insns(
        [
          PutObject,
          PutObject,
          OptPlus,
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
      assert_stdout("foo\n", source_code)
    end

    def test_branchunless_doesnt_jump_if_true
      source_code = "if 'bar'.empty?; puts 'foo'; end"
      assert_insns(
        [
          PutString,
          OptEmptyP,
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
  end
end
