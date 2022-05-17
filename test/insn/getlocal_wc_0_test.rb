# frozen_string_literal: true

require "test_helper"

module YARV
  class GetLocalWC0Test < TestCase
    def test_execute
      assert_insns(
        [PutObject, SetLocalWC0, GetLocalWC0, Leave],
        "value = 5; value"
      )
      assert_stdout("5\n", "value = 5; p value")
    end
  end
end
