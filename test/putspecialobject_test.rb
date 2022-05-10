# frozen_string_literal: true

require_relative "test_case"

module YARV
  class PutSpecialObjectTest < TestCase
    def test_execute
      assert_insns([PutSpecialObject, Proc, Leave], "class Foo; end")
      assert_stdout("", "class Foo; end")
    end
  end
end
