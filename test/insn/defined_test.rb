# frozen_string_literal: true

require "test_helper"

module YARV
  class DefinedTest < TestCase
    def test_execute
      assert_insns([PutNil, Defined, Leave], "defined?($foo)")
      assert_stdout("global-variable\n", "$foo = 1; puts defined?($foo)")
    end
  end
end
