# frozen_string_literal: true

require_relative "test_case"

module YARV
  class SendTest < TestCase
    def test_execute_creates_block_iseq
      source = <<~SOURCE
        true.tap {|i| i }
      SOURCE
      assert_insns(
        [
          PutObject,
          Send,
          Leave
        ],
        source
      )
      iseq = YARV.compile(source)
      assert_equal(
        [GetLocalWC0, Leave],
        iseq.insns[1].block_iseq.insns.map(&:class)
      )
    end

    def test_execute
      source = <<~SOURCE
        true.tap {|i| p i }
      SOURCE

      assert_stdout("true\n", source)
    end
  end
end
