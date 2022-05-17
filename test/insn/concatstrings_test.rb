# frozen_string_literal: true

require "test_helper"

module YARV
  class ConcatstringsTest < TestCase
    def test_execute
      assert_insns(
        [
          PutObject,
          PutObject,
          Dup,
          ObjToString,
          AnyToString,
          ConcatStrings,
          Leave
        ],
        '"#{5}"'
      )
      assert_stdout("\"5\"\n", 'p "#{5}"')
    end

    def test_produces_the_expected_instructions
      assert_stdout_for_instructions(
        "5\n",
        [
          [:putself],
          [:putobject, ""],
          [:putobject, 5],
          [:dup],
          [:objtostring, { mid: :to_s, flag: 20, orig_argc: 0 }],
          [:anytostring],
          [:concatstrings, 2],
          [:opt_send_without_block, { mid: :puts, flag: 20, orig_argc: 1 }],
          [:leave]
        ]
      )
    end
  end
end
