# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptGtTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptGt, Leave], "4 > 3")
      assert_stdout("true\n", "puts 4 > 3")
    end
  end
end
