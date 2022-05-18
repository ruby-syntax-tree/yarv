# frozen_string_literal: true

require "test_helper"

module YARV
  class OptNilPTest < TestCase
    def test_execute
      assert_insns([PutString, OptNilP, Leave], "''.nil?")
      assert_stdout("false\n", "p ''.nil?")
    end
  end
end
