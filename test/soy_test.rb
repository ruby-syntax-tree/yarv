# frozen_string_literal: true

require_relative "test_helper"

module YARV
  class SOYTest < Test::Unit::TestCase
    def test_local
      assert_soy(<<~DISASM, "14 + 2")
        flowchart TD
          node_0(0000 PutObject)
          node_1(0001 PutObject)
          node_2(0002 OptPlus)
          node_3(0003 Leave)
          node_0 --> |0| node_2
          linkStyle 0 stroke:green;
          node_1 --> |1| node_2
          linkStyle 1 stroke:green;
          node_2 --> node_3
          linkStyle 2 stroke:red;
          node_2 --> |0| node_3
          linkStyle 3 stroke:green;
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
          node_5(0005 Jump)
          node_6(0006 PutObjectInt2Fix1)
          node_7(0007 PutObject)
          node_8(0008 OptPlus)
          node_9(0009 Leave)
          node_1000(1000 ψ)
          node_1001(1001 φ)
          node_0 --> |0| node_2
          linkStyle 0 stroke:green;
          node_1 --> |1| node_2
          linkStyle 1 stroke:green;
          node_2 --> node_3
          linkStyle 2 stroke:red;
          node_2 --> |0| node_3
          linkStyle 3 stroke:green;
          node_3 --> |branched| node_6
          linkStyle 4 stroke:red;
          node_3 --> |fallthrough| node_5
          linkStyle 5 stroke:red;
          node_4 --> |0005| node_1001
          linkStyle 6 stroke:green;
          node_5 --> |branched| node_1000
          linkStyle 7 stroke:red;
          node_6 --> |branched| node_1000
          linkStyle 8 stroke:red;
          node_6 --> |0006| node_1001
          linkStyle 9 stroke:green;
          node_7 --> |1| node_8
          linkStyle 10 stroke:green;
          node_8 --> node_9
          linkStyle 11 stroke:red;
          node_8 --> |0| node_9
          linkStyle 12 stroke:green;
          node_1000 --> node_8
          linkStyle 13 stroke:red;
          node_1001 -.-> node_1000
          node_1001 --> |0| node_8
          linkStyle 15 stroke:green;
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
          node_6(0006 Jump)
          node_7(0007 PutObjectInt2Fix1)
          node_8(0008 OptPlus)
          node_9(0009 Leave)
          node_1002(1002 ψ)
          node_1004(1004 φ)
          node_0 --> |0| node_8
          linkStyle 0 stroke:green;
          node_1 --> |0| node_3
          linkStyle 1 stroke:green;
          node_2 --> |1| node_3
          linkStyle 2 stroke:green;
          node_3 --> node_4
          linkStyle 3 stroke:red;
          node_3 --> |0| node_4
          linkStyle 4 stroke:green;
          node_4 --> |branched| node_7
          linkStyle 5 stroke:red;
          node_4 --> |fallthrough| node_6
          linkStyle 6 stroke:red;
          node_5 --> |0006| node_1004
          linkStyle 7 stroke:green;
          node_6 --> |branched| node_1002
          linkStyle 8 stroke:red;
          node_7 --> |branched| node_1002
          linkStyle 9 stroke:red;
          node_7 --> |0007| node_1004
          linkStyle 10 stroke:green;
          node_8 --> node_9
          linkStyle 11 stroke:red;
          node_8 --> |0| node_9
          linkStyle 12 stroke:green;
          node_1002 --> node_8
          linkStyle 13 stroke:red;
          node_1004 -.-> node_1002
          node_1004 --> |1| node_8
          linkStyle 15 stroke:green;
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
          node_4(0004 Jump)
          node_5(0005 PutNil)
          node_6(0006 Pop)
          node_7(0007 Jump)
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
          node_0 --> |0| node_1
          linkStyle 0 stroke:green;
          node_1 --> node_3
          linkStyle 1 stroke:red;
          node_2 --> |0| node_3
          linkStyle 2 stroke:green;
          node_3 --> node_4
          linkStyle 3 stroke:red;
          node_4 --> |branched| node_16
          linkStyle 4 stroke:red;
          node_5 --> |0| node_6
          linkStyle 5 stroke:green;
          node_7 --> |branched| node_16
          linkStyle 6 stroke:red;
          node_8 --> node_9
          linkStyle 7 stroke:red;
          node_8 --> |0| node_10
          linkStyle 8 stroke:green;
          node_9 --> node_10
          linkStyle 9 stroke:red;
          node_9 --> |1| node_10
          linkStyle 10 stroke:green;
          node_10 --> node_11
          linkStyle 11 stroke:red;
          node_10 --> |0| node_11
          linkStyle 12 stroke:green;
          node_11 --> node_12
          linkStyle 13 stroke:red;
          node_12 --> node_14
          linkStyle 14 stroke:red;
          node_12 --> |0| node_14
          linkStyle 15 stroke:green;
          node_13 --> |1| node_14
          linkStyle 16 stroke:green;
          node_14 --> node_15
          linkStyle 17 stroke:red;
          node_14 --> |0| node_15
          linkStyle 18 stroke:green;
          node_15 --> |branched| node_16
          linkStyle 19 stroke:red;
          node_16 --> node_18
          linkStyle 20 stroke:red;
          node_16 --> |0| node_18
          linkStyle 21 stroke:green;
          node_17 --> |1| node_18
          linkStyle 22 stroke:green;
          node_18 --> node_19
          linkStyle 23 stroke:red;
          node_18 --> |0| node_19
          linkStyle 24 stroke:green;
          node_19 --> |branched| node_8
          linkStyle 25 stroke:red;
          node_19 --> |fallthrough| node_22
          linkStyle 26 stroke:red;
          node_20 --> |0| node_21
          linkStyle 27 stroke:green;
          node_22 --> node_23
          linkStyle 28 stroke:red;
          node_22 --> |0| node_23
          linkStyle 29 stroke:green;
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
          linkStyle 0 stroke:red;
          node_1 --> |0| node_2
          linkStyle 1 stroke:green;
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
          linkStyle 0 stroke:red;
          node_0 --> |0| node_2
          linkStyle 1 stroke:green;
          node_1 --> |1| node_2
          linkStyle 2 stroke:green;
          node_2 --> node_3
          linkStyle 3 stroke:red;
          node_2 --> |0| node_3
          linkStyle 4 stroke:green;
          node_3 --> |branched| node_7
          linkStyle 5 stroke:red;
          node_3 --> |fallthrough| node_4
          linkStyle 6 stroke:red;
          node_4 --> node_5
          linkStyle 7 stroke:red;
          node_4 --> |0| node_5
          linkStyle 8 stroke:green;
          node_6 --> |0| node_10
          linkStyle 9 stroke:green;
          node_7 --> node_9
          linkStyle 10 stroke:red;
          node_7 --> |0| node_9
          linkStyle 11 stroke:green;
          node_8 --> |1| node_9
          linkStyle 12 stroke:green;
          node_9 --> node_10
          linkStyle 13 stroke:red;
          node_9 --> |1| node_10
          linkStyle 14 stroke:green;
          node_10 --> node_12
          linkStyle 15 stroke:red;
          node_10 --> |0| node_16
          linkStyle 16 stroke:green;
          node_11 --> |0| node_15
          linkStyle 17 stroke:green;
          node_12 --> node_14
          linkStyle 18 stroke:red;
          node_12 --> |0| node_14
          linkStyle 19 stroke:green;
          node_13 --> |1| node_14
          linkStyle 20 stroke:green;
          node_14 --> node_15
          linkStyle 21 stroke:red;
          node_14 --> |1| node_15
          linkStyle 22 stroke:green;
          node_15 --> node_16
          linkStyle 23 stroke:red;
          node_15 --> |1| node_16
          linkStyle 24 stroke:green;
          node_16 --> node_17
          linkStyle 25 stroke:red;
          node_16 --> |0| node_17
          linkStyle 26 stroke:green;
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
