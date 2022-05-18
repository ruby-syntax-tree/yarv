# frozen_string_literal: true

require "test_helper"

module YARV
  class OptLtLtTest < TestCase
    def test_execute
      assert_insns([PutString, PutString, OptLtLt, Leave], "'' << 'a'")
      assert_stdout("\"a\"\n", "p (+'') << 'a'")
    end
  end
end
