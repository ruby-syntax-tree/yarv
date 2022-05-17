# frozen_string_literal: true

require_relative "test_case"

module YARV
  class SendTest < TestCase
    def test_executes_correctly
      source = <<~SOURCE
        true.tap { |i| p i }
      SOURCE

      assert_insns([PutObject, Send, Leave], source)
      iseq = YARV.compile(source)
      assert_equal(
        [PutSelf, GetLocalWC0, OptSendWithoutBlock, Leave],
        iseq.insns[1].block_iseq.insns.map(&:class)
      )

      assert_stdout("true\n", source)
    end

    def test_executes_without_block_correctly
      source = "puts 'hello'"
      iseq = YARV.compile(source, specialized_instruction: false)
      assert_equal([PutSelf, PutString, Send, Leave], iseq.insns.map(&:class))

      assert_stdout("hello\n", source)
    end
  end
end
