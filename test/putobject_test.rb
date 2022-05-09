# frozen_string_literal: true

require_relative "test_case"

module YARV
  class PutObjectTest < TestCase
    def test_execute
      assert_insns([PutObject, Leave], "5")
      assert_stdout("5\n", "puts 5")
    end
  end
end
