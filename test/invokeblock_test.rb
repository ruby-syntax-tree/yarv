# frozen_string_literal: true

require_relative "test_case"

module YARV
  class InvokeBlockTest < TestCase
    def test_execute
      code = <<-CODE
        def x
          return yield self
        end
      CODE
      assert_insns(
        [DefineMethod, PutObject, Leave],
        code
      )

      iseq = YARV.compile(code)
      assert_equal(
        [PutSelf, InvokeBlock, Leave],
        iseq.insns.first.iseq.insns
      )
      # assert_stdout("")
    end
  end
end
