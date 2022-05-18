# frozen_string_literal: true

require "test_helper"

module YARV
  class OptArefTest < TestCase
    def test_execute
      assert_insns([PutObject, PutObject, OptAref, Leave], "7[2]")
      assert_stdout("1\n", "p 7[2]")
    end
  end
end
