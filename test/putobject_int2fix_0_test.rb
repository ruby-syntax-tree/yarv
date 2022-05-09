# frozen_string_literal: true

require_relative "test_case"

module YARV
  class PutObjectInt2Fix0Test < TestCase
    def test_execute
      assert_insns([PutSelf, PutObjectInt2Fix0, OptSendWithoutBlock, Leave], "puts 0")
      assert_stdout("0\n", "puts 0")
    end
  end
end
