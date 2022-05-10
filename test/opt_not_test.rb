# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class OptNotTest < TestCase
    def test_execute
      assert_insns([PutObject, OptNot, Leave], "!true")
      assert_stdout("false\n", "p !true")
      assert_stdout("true\n", "p !!true")
    end
  end
end
