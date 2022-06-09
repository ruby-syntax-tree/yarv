# frozen_string_literal: true

require "test_helper"

module YARV
  class SOYTest < Test::Unit::TestCase
    def test_local
      assert_soy(<<~DISASM, "14 + 2")
        flowchart TD
          node_0(0000 PutObject)
          node_1(0001 PutObject)
          node_2(0002 OptPlus)
          node_3(0003 Leave)
          node_0 --> node_2
          node_1 --> node_2
          node_2 --> node_3
          node_2 --> node_3
      DISASM
    end

    def test_simple_bbarg
      assert_soy(<<~DISASM, "(14 < 0 ? -1 : +1) + 100")
        flowchart TD
          node_0(0000 PutObject)
          node_1(0001 PutObjectInt2Fix0)
          node_2(0002 OptLt)
          node_3(0003 BranchUnless)
          node_4(0004 PutObject)
          node_6(0006 PutObjectInt2Fix1)
          node_7(0007 PutObject)
          node_8(0008 OptPlus)
          node_9(0009 Leave)
          node_1000(1000 ψ)
          node_1001(1001 φ)
          node_0 --> node_2
          node_1 --> node_2
          node_2 --> node_3
          node_2 --> node_3
          node_3 --> node_6
          node_3 --> node_1000
          node_4 --> node_1001
          node_6 --> node_1000
          node_6 --> node_1001
          node_7 --> node_8
          node_8 --> node_9
          node_8 --> node_9
          node_1000 --> node_8
          node_1001 --> node_1000
          node_1001 --> node_8
      DISASM
    end

    def test_indirect_bbarg
      assert_soy(<<~DISASM, "100 + (14 < 0 ? -1 : +1)")
        flowchart TD
          node_0(0000 PutObject)
          node_1(0001 PutObject)
          node_2(0002 PutObjectInt2Fix0)
          node_3(0003 OptLt)
          node_4(0004 BranchUnless)
          node_5(0005 PutObject)
          node_7(0007 PutObjectInt2Fix1)
          node_8(0008 OptPlus)
          node_9(0009 Leave)
          node_1002(1002 ψ)
          node_1004(1004 φ)
          node_0 --> node_8
          node_1 --> node_3
          node_2 --> node_3
          node_3 --> node_4
          node_3 --> node_4
          node_4 --> node_7
          node_4 --> node_1002
          node_5 --> node_1004
          node_7 --> node_1002
          node_7 --> node_1004
          node_8 --> node_9
          node_8 --> node_9
          node_1002 --> node_8
          node_1004 --> node_1002
          node_1004 --> node_8
      DISASM
    end

    def test_loop
      source = <<~SOURCE
        n = 10
        sum = 0
        while n > 0
          sum += n
          n -= 1
        end
        sum
      SOURCE
      assert_soy(<<~DISASM, source)
        flowchart TD
          node_0(0000 PutObject)
          node_1(0001 SetLocalWC0)
          node_2(0002 PutObjectInt2Fix0)
          node_3(0003 SetLocalWC0)
          node_5(0005 PutNil)
          node_6(0006 Pop)
          node_8(0008 GetLocalWC0)
          node_9(0009 GetLocalWC0)
          node_10(0010 OptPlus)
          node_11(0011 SetLocalWC0)
          node_12(0012 GetLocalWC0)
          node_13(0013 PutObjectInt2Fix1)
          node_14(0014 OptMinus)
          node_15(0015 SetLocalWC0)
          node_16(0016 GetLocalWC0)
          node_17(0017 PutObjectInt2Fix0)
          node_18(0018 OptGt)
          node_19(0019 BranchIf)
          node_20(0020 PutNil)
          node_21(0021 Pop)
          node_22(0022 GetLocalWC0)
          node_23(0023 Leave)
          node_0 --> node_1
          node_1 --> node_3
          node_2 --> node_3
          node_3 --> node_16
          node_5 --> node_6
          node_8 --> node_9
          node_8 --> node_10
          node_9 --> node_10
          node_9 --> node_10
          node_10 --> node_11
          node_10 --> node_11
          node_11 --> node_12
          node_12 --> node_14
          node_12 --> node_14
          node_13 --> node_14
          node_14 --> node_15
          node_14 --> node_15
          node_15 --> node_16
          node_16 --> node_18
          node_16 --> node_18
          node_17 --> node_18
          node_18 --> node_19
          node_18 --> node_19
          node_19 --> node_8
          node_19 --> node_22
          node_20 --> node_21
          node_22 --> node_23
          node_22 --> node_23
      DISASM
    end

    def test_fib
      source = <<~SOURCE
        def fib(n)
          if n < 2
            n
          else
            fib(n - 1) + fib(n - 2)
          end
        end
      SOURCE
      assert_soy(<<~DISASM, source)
        flowchart TD
          node_0(0000 DefineMethod)
          node_1(0001 PutObject)
          node_2(0002 Leave)
          node_0 --> node_2
          node_1 --> node_2
        flowchart TD
          node_0(0000 GetLocalWC0)
          node_1(0001 PutObject)
          node_2(0002 OptLt)
          node_3(0003 BranchUnless)
          node_4(0004 GetLocalWC0)
          node_5(0005 Leave)
          node_6(0006 PutSelf)
          node_7(0007 GetLocalWC0)
          node_8(0008 PutObjectInt2Fix1)
          node_9(0009 OptMinus)
          node_10(0010 OptSendWithoutBlock)
          node_11(0011 PutSelf)
          node_12(0012 GetLocalWC0)
          node_13(0013 PutObject)
          node_14(0014 OptMinus)
          node_15(0015 OptSendWithoutBlock)
          node_16(0016 OptPlus)
          node_17(0017 Leave)
          node_0 --> node_2
          node_0 --> node_2
          node_1 --> node_2
          node_2 --> node_3
          node_2 --> node_3
          node_3 --> node_7
          node_3 --> node_4
          node_4 --> node_5
          node_4 --> node_5
          node_6 --> node_10
          node_7 --> node_9
          node_7 --> node_9
          node_8 --> node_9
          node_9 --> node_10
          node_9 --> node_10
          node_10 --> node_12
          node_10 --> node_16
          node_11 --> node_15
          node_12 --> node_14
          node_12 --> node_14
          node_13 --> node_14
          node_14 --> node_15
          node_14 --> node_15
          node_15 --> node_16
          node_15 --> node_16
          node_16 --> node_17
          node_16 --> node_17
      DISASM
    end

    private

    def assert_soy(expected, source)
      string = +""
      compiled = YARV.compile(source)
      compiled.all_iseqs.each do |iseq|
        cfg = YARV::CFG.new(iseq)
        dfg = YARV::DFG.new(cfg)
        soy = YARV::SOY.new(dfg)
        string << soy.mermaid
      end
      assert_equal(expected, string)
    end
  end
end
