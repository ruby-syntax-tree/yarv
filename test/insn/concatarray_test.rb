# frozen_string_literal: true

require "test_helper"

module YARV
  class ConcatarrayTest < TestCase
    def test_execute
      assert_insns([DupArray, PutObject, ConcatArray, Leave], "[1,*2]")
      assert_stdout("[1, 2]\n", "p [1, *2]")
    end

    def test_coerces_the_left_element
      assert_stdout_for_instructions(
        "[2, 3]\n",
        [
          [:putself],
          [:putobject, 2],
          [:putobject, 3],
          [:concatarray],
          [:opt_send_without_block, { mid: :p, flag: 20, orig_argc: 1 }]
        ]
      )
    end

    def test_duplicates_the_left_element
      assert_stdout_for_instructions(
        "[1]\n",
        [
          [:putself],
          [:duparray, [1]],
          [:dup],
          [:putobject, 2],
          [:concatarray],
          [:pop],
          [:opt_send_without_block, { mid: :p, flag: 20, orig_argc: 1 }]
        ]
      )
    end
  end
end
