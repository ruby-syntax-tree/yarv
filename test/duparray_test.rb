# frozen_string_literal: true

require_relative "test_case"

module YARV
  class DupArrayTest < TestCase
    def test_execute
      assert_insns([DupArray, Leave], "[true]")
      assert_stdout("true\n", "p [true][0]")
    end

    def test_duplicates_the_literal
      assert_stdout("[true]\n", "def foo() [true] end; foo.push(false); p foo")
    end
  end
end
