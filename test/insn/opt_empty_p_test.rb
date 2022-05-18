# frozen_string_literal: true

require "test_helper"

module YARV
  class OptEmptyPTest < TestCase
    def test_execute
      assert_insns([PutString, OptEmptyP, Leave], "''.empty?")
      assert_stdout("true\n", "p ''.empty?")
    end
  end
end
