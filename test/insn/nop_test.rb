# frozen_string_literal: true

require "test_helper"

module YARV
  class NopTest < TestCase
    def test_execute
      assert_insns(
        [PutSelf, OptSendWithoutBlock, Nop, Leave],
        "raise rescue true"
      )
    end
  end
end
