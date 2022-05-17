# frozen_string_literal: true

require "test_helper"

module YARV
  class OptLengthTest < TestCase
    def test_execute
      assert_insns([PutString, OptLength, Leave], "''.length")
      assert_stdout("0\n", "p ''.length")
    end
  end
end
