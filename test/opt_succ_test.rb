# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class OptSuccTest < TestCase
    def test_execute
      assert_insns([PutString, OptSucc, Leave], "'a'.succ")
      assert_stdout("\"b\"\n", "p 'a'.succ")
    end
  end
end
