# frozen_string_literal: true

require_relative "test_case"

module YARV
  class SendTest < TestCase
    def test_compile_returns_correct_instructions
      source = <<~SOURCE
        "hello".tap {}
      SOURCE

      assert_insns(
        [PutString, Send, Leave],
        source
      )
      iseq = YARV.compile(source)
      assert_equal(
        [PutNil, Leave],
        iseq.insns[1].block_iseq.insns.map(&:class)
      )

      assert_stdout("", source)
    end
  end
end
