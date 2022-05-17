# frozen_string_literal: true

require "test_helper"

module YARV
  class OptNewArrayMaxTest < TestCase
    def test_execute
      assert_insns(
        [PutObject, PutObject, Dup, SetLocalWC0, OptNewArrayMax, Leave],
        "[2, x = 3].max"
      )
      assert_stdout("3\n", "p [2, x = 3].max")
    end
  end
end
