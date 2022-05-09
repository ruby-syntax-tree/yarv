# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptGetInlineCacheTest < TestCase
    def test_execute
      assert_insns(
        [OptGetInlineCache, PutObject, GetConstant, OptSetInlineCache, Leave],
        "Constant"
      )
      assert_stdout("Object\n", "puts Object")
    end
  end
end
