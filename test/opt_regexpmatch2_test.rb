# frozen_string_literal: true

require_relative "test_case"

module YARV
  class OptRegexpmatch2Test < TestCase
    def test_execute
      # # should work with string and regexp literals
      # assert_insns([PutString, PutObject, OptRegexpmatch2, Leave], "'str' =~ /regexp/")
      # assert_insns([PutObject, PutString, OptRegexpmatch2, Leave], "/regexp/ =~ 'str'")

      # # should work with variables
      # assert_insns([PutSelf, OptSendWithoutBlock, PutObject, OptRegexpmatch2, Leave], "var =~ /regexp/")
      # assert_insns([PutSelf, OptSendWithoutBlock, PutObject, OptRegexpmatch2, Leave], "/regexp/ =~ var")
      # assert_insns([PutSelf, OptSendWithoutBlock, PutSelf, OptSendWithoutBlock, OptRegexpmatch2, Leave], "var =~ var")

      # # should work with object instances without out-of-the-box support
      # assert_insns([PutObjectInt2Fix0, PutObject, OptRegexpmatch2, Leave], "0 =~ /0/")

      # usage
      assert_stdout("0\n", "p 'str' =~ /str/")
      assert_stdout("1\n", "p 'str' =~ /tr/")
      assert_stdout("nil\n", "p 'str' =~ /blah/")
      assert_stdout("0\n", "p (/str/) =~ 'str'")
      assert_stdout("1\n", "p (/tr/) =~ 'str'")
      assert_stdout("nil\n", "p (/blah/) =~ 'str'")
    end
  end
end
