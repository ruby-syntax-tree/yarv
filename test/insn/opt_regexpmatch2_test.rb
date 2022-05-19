# frozen_string_literal: true

require "test_helper"

module YARV
  class OptRegexpMatch2Test < TestCase
    def test_execute
      assert_insns(
        [
          PutObject,
          PutString,
          OptRegexpMatch2,
          Dup,
          BranchUnless,
          Pop,
          GetGlobal,
          Leave
        ],
        "/true/ =~ 'true' && $~"
      )

      assert_stdout("nil\n", "p (/true/ =~ 'true' && $~)")
    end
  end
end
