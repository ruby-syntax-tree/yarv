# frozen_string_literal: true

require "test_helper"

module YARV
  class OptSizeTest < TestCase
    def test_execute
      assert_insns([PutString, OptSize, Leave], "''.size")
      assert_stdout("4\n", "p '1111'.size")
    end
  end
end
