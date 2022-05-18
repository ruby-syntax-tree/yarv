# frozen_string_literal: true

require "test_helper"

module YARV
  class SetGlobalTest < TestCase
    def test_execute
      assert_insns([PutObject, Dup, SetGlobal, Leave], "$global = 5")
      assert_stdout("5\n", "p $global = 5")
    end
  end
end
