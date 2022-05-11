# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class OptSizeTest < TestCase
    def test_execute
      assert_insns([PutString, OptSize, Leave], "''.size")
      assert_stdout("4\n", "p '1111'.size")
    end
  end
end
