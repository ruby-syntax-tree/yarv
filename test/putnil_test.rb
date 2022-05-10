# frozen_string_literal: true

require_relative "test_case"

module YARV
  class PutNilTest < TestCase
    def test_execute
      assert_insns([PutNil, Leave], "nil")
      assert_stdout("nil\n", "p nil")
    end
  end
end
