# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptEqTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptEq, Leave], "2 == 2")
      assert_stdout("true\n", "p 2 == 2")
    end
  end
end
