# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptModTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptMod, Leave], "4 % 2")
      assert_stdout("0\n", "puts 4 % 2")
    end
  end
end
