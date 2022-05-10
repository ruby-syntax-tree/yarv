# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class OptArefWithTest < TestCase
    def test_execute
      assert_insns([DupHash, OptArefWith, Leave], "{ 'test' => true }['test']")
      assert_stdout("true\n", "p({ 'test' => true }['test'])")
    end
  end
end
