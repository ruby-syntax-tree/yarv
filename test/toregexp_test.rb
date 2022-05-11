# frozen_string_literal: true

require_relative "test_case"

module YARV
  class ToregexpTest < TestCase
    def test_execute
      assert_insns(
        [PutObject, PutObject, Dup, ObjToString, AnyToString, Toregexp, Leave],
        '/#{true}/'
      )
      assert_stdout("\"/true/\"\n", 'p "/#{true}/"')
    end

    def test_execute_multiple_interpolations
      assert_insns(
        [PutObject, PutObject, Dup, ObjToString, AnyToString, Toregexp, Leave],
        '/#{true}/'
      )
      assert_stdout("\"/true 5/\"\n", 'p "/#{true} #{5}/"')
    end

    def test_produces_the_expected_instructions
      assert_stdout_for_instructions(
        "/true/\n",
        [
          [:putself],
          [:putobject, ""],
          [:putobject, true],
          [:dup],
          [:objtostring, { mid: :to_s, flag: 20, orig_argc: 0 }],
          [:anytostring],
          [:toregexp, 0, 2],
          [:opt_send_without_block, { mid: :p, flag: 20, orig_argc: 1 }],
          [:leave]
        ]
      )
    end
  end
end
