# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class OptAsetTest < TestCase
    def test_execute
      assert_insns(
        [PutNil, NewHash, PutObject, PutString, Setn, OptAset, Pop, Leave],
        "{}[:key] = 'val'",
        peephole_optimization: false
      )
      assert_stdout(
        "\"val\"\n",
        "p({}[:key] = 'val')",
        peephole_optimization: false
      )
    end
  end
end
