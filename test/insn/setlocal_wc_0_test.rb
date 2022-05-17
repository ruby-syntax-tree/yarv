# frozen_string_literal: true

require "test_helper"

module YARV
  class SetLocalWC0Test < TestCase
    def test_execute
      assert_insns([PutObject, Dup, SetLocalWC0, Leave], "value = 5")
      assert_stdout("5\n", "p value = 5")
    end
  end
end
