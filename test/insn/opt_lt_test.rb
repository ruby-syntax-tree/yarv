# frozen_string_literal: true

require "test_helper"

module YARV
  class OptLtTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptLt, Leave], "3 < 4")
      assert_stdout("true\n", "puts 3 < 4")
    end
  end
end
