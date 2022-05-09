# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class OptAndTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptAnd, Leave], "2 & 3")
      assert_stdout("2\n", "p 2 & 3")
    end
  end
end
