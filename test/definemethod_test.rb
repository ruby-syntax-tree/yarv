# frozen_string_literal: true

require_relative "test_case"

module YARV
  class DefineMethodTest < TestCase
    def test_execute
      source = <<~SOURCE
        def value = "value"
        puts value
      SOURCE

      assert_insns([DefineMethod, PutSelf, PutSelf, OptSendWithoutBlock, OptSendWithoutBlock, Leave], source)
      assert_stdout("value\n", source)
    end
  end
end
