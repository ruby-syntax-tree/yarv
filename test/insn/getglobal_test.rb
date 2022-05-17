# frozen_string_literal: true

require "test_helper"

module YARV
  class GetGlobalTest < TestCase
    def test_execute
      assert_insns([GetGlobal, Leave], "$$")
      assert_stdout("#{$$}\n", "p $$")
    end
  end
end
