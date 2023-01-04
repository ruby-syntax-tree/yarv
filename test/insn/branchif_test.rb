# frozen_string_literal: true

require "test_helper"

module YARV
  class BranchIfTest < TestCase
    def test_branchif_jumps_if_true
      source_code = "x = true; x ||= 'foo' ; puts x"
      assert_stdout("true\n", source_code)
    end

    def test_branchif_doesnt_jump_if_false
      source_code = "x = false; x ||= true; puts x"
      assert_stdout("true\n", source_code)
    end
  end
end
