# frozen_string_literal: true

require "test_helper"

module YARV
  class DupHashTest < TestCase
    def test_execute
      assert_insns([DupHash, Leave], "{ a: 1 }")
      assert_stdout("{:a=>1}\n", "p({ a: 1 })")
    end

    def test_hash_is_immutable
      ruby = <<~RUBY
        def foo
          { a: 1 }
        end
        foo.merge!({b: 2})
        p foo
      RUBY
      assert_stdout("{:a=>1}\n", ruby)
    end
  end
end
