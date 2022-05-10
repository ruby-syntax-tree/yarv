# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class SwapTest < TestCase
    def test_execute
      assert_insns(
        [PutNil, PutObject, Swap, Pop, OptNot, OptNot, Leave],
        "!!defined?([[]])"
      )
      assert_stdout("true\n", "p !!defined?([[]])")
    end
  end
end
