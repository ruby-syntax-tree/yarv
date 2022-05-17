# frozen_string_literal: true

require "test_helper"

module YARV
  class OptMinusTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptMinus, Leave], "3 - 2")
      assert_stdout("1\n", "p 3 - 2")
    end
  end
end
