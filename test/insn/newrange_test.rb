# frozen_string_literal: true

require "test_helper"

module YARV
  class NewRangeTest < TestCase
    def test_execute
      assert_insns(
        [PutNil, SetLocalWC0, GetLocalWC0, PutNil, NewRange, Leave],
        "x=nil;x.."
      )
      assert_stdout("nil..nil\nnil...nil\n", "x=nil;p(x..);p(x...)")
    end
  end
end
