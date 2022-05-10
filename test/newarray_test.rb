# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class NewArrayTest < TestCase
    def test_execute
      assert_insns([NewArray, Leave], "[]")
      assert_stdout(%([1, true, "string"]\n), "p([1, true, 'string'])")
    end
  end
end
