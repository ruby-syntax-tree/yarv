# frozen_string_literal: true

require "test_helper"

module YARV
  class OptPlusTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptPlus, Leave], "2 + 3")
      assert_stdout("5\n", "p 2 + 3")
    end
  end
end
