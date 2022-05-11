# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptNewArrayMinTest < TestCase
    def test_execute
      assert_insns(
        [PutObject, PutObject, Dup, SetLocalWC0, OptNewArrayMin, Leave],
        "[2, x = 3].min"
      )
      assert_stdout("2\n", "p [2, x = 3].min")
    end
  end
end
