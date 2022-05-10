# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptLeTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptLe, Leave], "3 <= 4")
      assert_stdout("true\n", "puts 3 <= 4")
    end
  end
end
