# frozen_string_literal: true

require "test_helper"

module YARV
  class SetLocalWC1Test < TestCase
    def test_execute
      source = "value = 5; print(self.then { value = 5 })"

      assert_equal(
        [PutObject, Dup, SetLocalWC1, Leave],
        YARV.compile(source).insns[4].block_iseq.insns.map(&:class)
      )
    end
  end
end
