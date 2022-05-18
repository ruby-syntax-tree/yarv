# frozen_string_literal: true

require "test_helper"

module YARV
  class PutSelfTest < TestCase
    def test_execute
      assert_insns([PutSelf, Leave], "self")
      assert_stdout("main\n", "p self")
    end
  end
end
