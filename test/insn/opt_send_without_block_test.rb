# frozen_string_literal: true

require "test_helper"

module YARV
  class OptSendWithoutBlockTest < TestCase
    def test_execute
      assert_insns(
        [PutSelf, PutString, OptSendWithoutBlock, Leave],
        "puts 'Hello, world!'"
      )
      assert_stdout("Hello, world!\n", "puts 'Hello, world!'")
    end
  end
end
