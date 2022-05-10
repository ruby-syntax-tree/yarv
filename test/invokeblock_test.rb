# frozen_string_literal: true

require_relative "test_case"

module YARV
  class InvokeBlockTest < TestCase
    def test_execute
      code = <<-CODE
        def x
          yield self
        end

        x do
          true
        end
      CODE
      assert_insns(
        [DefineMethod, PutSelf, Leave],
        code
      )
      # iseq = YARV.compile(code)
      # assert_insns(
      #   [PutSelf, InvokeBlock, Leave],
      #   iseq.insns.first.iseq.insns
      # )
      # assert_stdout("")
    end
  end
end
