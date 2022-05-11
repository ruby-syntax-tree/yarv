# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptNeqTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptNeq, Leave], "2 != 2")
      assert_stdout("false\n", "p 2 != 2")
      assert_stdout("true\n", "p 1 != 2")
    end
  end
end
