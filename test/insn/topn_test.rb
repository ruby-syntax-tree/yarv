# frozen_string_literal: true

require "test_helper"

module YARV
  class TopNTest < TestCase
    def test_top_n_gets_nth_element_from_stack
      source_code = "case 3 when 1..5 then puts 'foo' end"
      assert_stdout("foo\n", source_code)
    end
  end
end
