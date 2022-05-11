# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptMultTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptMult, Leave], "3 * 2")
      assert_stdout("6\n", "p 3 * 2")
    end
  end
end
