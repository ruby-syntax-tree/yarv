# frozen_string_literal: true

require "test_helper"

module YARV
  class SplatArrayTest < TestCase
    def test_execute
      assert_insns([PutObject, SplatArray, Dup, SetLocalWC0, Leave], "x = *(5)")
      assert_stdout("[5]\n", "x = *(5); p x")
    end

    def test_coerces_the_element
      assert_stdout_for_instructions(
        "[2]\n",
        [
          [:putself],
          [:putobject, 2],
          [:splatarray, true],
          [:opt_send_without_block, { mid: :p, flag: 20, orig_argc: 1 }]
        ]
      )
    end
  end
end
