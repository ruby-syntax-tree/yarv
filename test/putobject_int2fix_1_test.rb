# frozen_string_literal: true

require_relative "test_case"

module YARV
  class PutObjectInt2Fix1Test < TestCase
    def test_execute
      assert_insns(
        [PutSelf, PutObjectInt2Fix1, OptSendWithoutBlock, Leave],
        "puts 1"
      )
      assert_stdout("1\n", "puts 1")
    end
  end
end
