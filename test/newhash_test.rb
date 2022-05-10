# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class NewHashTest < TestCase
    def test_execute
      assert_insns([NewHash, Leave], "{}")
      assert_stdout("{:a=>2}\n", "k=:a;v=2;p({k=>v})")
    end
  end
end
