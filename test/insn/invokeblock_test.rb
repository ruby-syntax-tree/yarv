# frozen_string_literal: true

require "test_helper"

module YARV
  class InvokeBlockTest < TestCase
    def test_executes_correctly
      source = <<~SOURCE
        def foo
          yield(10)
        end

        foo do |x|
          p x + 1
        end
      SOURCE

      assert_insns([DefineMethod, PutSelf, Send, Leave], source)
      iseq = YARV.compile(source)
      assert_equal(
        [PutObject, InvokeBlock, Leave],
        iseq.insns[0].iseq.insns.map(&:class)
      )

      assert_stdout("11\n", source)
    end
  end
end
