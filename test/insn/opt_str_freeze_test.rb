# frozen_string_literal: true

require "test_helper"

module YARV
  class OptStrFreezeTest < TestCase
    def test_execute
      assert_insns([OptStrFreeze, Leave], "\"string\".freeze")
      assert_stdout("\"string\"\n", "p(-'string')")
    end
  end
end
