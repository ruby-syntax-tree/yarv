# frozen_string_literal: true

require_relative "test_case"

module YARV
  class InternTest < TestCase
    def test_execute
      assert_insns([PutString, Intern, Leave], ':"#{"foo"}"')
      assert_stdout(":foo\n", 'p :"#{"foo"}"')
    end
  end
end
