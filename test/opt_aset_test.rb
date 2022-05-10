require_relative "./test_case"

module YARV
  class OptAsetTest < TestCase
    def test_execute
      assert_insns([PutNil, NewHash, PutObject, PutString, OptAset, Pop, Leave], "{}[:key] = 'val'", peephole_optimization: false)
      assert_stdout("val\n", "{}[:key] = 'val'")
    end
  end
end
