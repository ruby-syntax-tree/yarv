# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class OptCaseDispatchTest < TestCase
    def test_opt_case_dispatch_jumps_to_correct_branch
      source_code = "case 1 when 0 then puts 'foo' else puts 'bar' end"
      assert_stdout("bar\n", source_code)
    end

    def test_opt_case_dispatch_can_use_cd_hash_to_jump_to_correct_branch
      source_code = "case 1 when 1 then puts 'foo' else puts 'bar' end"
      assert_stdout("foo\n", source_code)
    end
  end
end
