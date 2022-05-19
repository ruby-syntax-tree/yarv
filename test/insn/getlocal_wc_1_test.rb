# frozen_string_literal: true

require "test_helper"

module YARV
  class GetLocalWC1Test < TestCase
    def test_execute
      source = "value = 5; print(self.then { value })"

      assert_equal(
        [GetLocalWC1, Leave],
        YARV.compile(source).insns[4].block_iseq.insns.map(&:class)
      )
    end
  end
end
