# frozen_string_literal: true

require_relative "test_case"

module YARV
  class SendTest < TestCase
    def test_compile_returns_correct_instructions
      source = <<~SOURCE
        true.tap { |i| p i }
      SOURCE

      assert_insns(
        [PutObject, Send, Leave],
        source
      )
      iseq = YARV.compile(source)
      assert_equal(
        [PutSelf, GetLocalWC0, OptSendWithoutBlock, Leave],
        iseq.insns[1].block_iseq.insns.map(&:class)
      )

      assert_stdout("true\n", source)
    end
  end
end
