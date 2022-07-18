# frozen_string_literal: true

require_relative "test_helper"

module YARV
  class DFGTest < Test::Unit::TestCase
    # Only uses local dataflow.
    def test_local
      assert_dfg(<<~DISASM, "14 + 2")
        == dfg #<ISeq:<compiled>>
        block_0:
            0000 putobject                              14 # out: 0002
            0001 putobject                              2 # out: 0002
            0002 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr] # in: 0000, 0001; out: 0003
            0003 leave # in: 0002
                # to: leaves
      DISASM
    end

    # Triggers a simple basic block argument - the value for the add may come
    # from either side of the ternary.
    def test_simple_bbarg
      assert_dfg(<<~DISASM, "(14 < 0 ? -1 : +1) + 100")
        == dfg #<ISeq:<compiled>>
        block_0:
            0000 putobject                              14 # out: 0002
            0001 putobject_INT2FIX_0_ # out: 0002
            0002 opt_lt                                 <calldata!mid:<, argc:1, ARGS_SIMPLE>[CcCr] # in: 0000, 0001; out: 0003
            0003 branchunless                           label_11 (6) # in: 0002
                # to: block_6, block_4
        block_4: # from: block_0
            0004 putobject                              -1 # out: out_0
            0005 jump                                   label_12 (7)
                # to: block_7
                # out: 0004
        block_6: # from: block_0
            0006 putobject_INT2FIX_1_ # out: out_0
                # to: block_7
                # out: 0006
        block_7: # from: block_4, block_6
                # in: in_0
            0007 putobject                              100 # out: 0008
            0008 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr] # in: in_0, 0007; out: 0009
            0009 leave # in: 0008
                # to: leaves
      DISASM
    end

    # Triggers an indirect basic block argument - the 100 value for the add
    # comes from block_0, and is used in block_8, but they aren't directly
    # connected. This should cause the basic blocks in between to take the
    # value as an input and pass it directly as an output.
    def test_indirect_bbarg
      assert_dfg(<<~DISASM, "100 + (14 < 0 ? -1 : +1)")
        == dfg #<ISeq:<compiled>>
        block_0:
            0000 putobject                              100 # out: out_0
            0001 putobject                              14 # out: 0003
            0002 putobject_INT2FIX_0_ # out: 0003
            0003 opt_lt                                 <calldata!mid:<, argc:1, ARGS_SIMPLE>[CcCr] # in: 0001, 0002; out: 0004
            0004 branchunless                           label_13 (7) # in: 0003
                # to: block_7, block_5
                # out: 0000
        block_5: # from: block_0
                # in: pass_0
            0005 putobject                              -1 # out: out_0
            0006 jump                                   label_14 (8)
                # to: block_8
                # out: pass_0, 0005
        block_7: # from: block_0
                # in: pass_0
            0007 putobject_INT2FIX_1_ # out: out_0
                # to: block_8
                # out: pass_0, 0007
        block_8: # from: block_5, block_7
                # in: in_0, in_1
            0008 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr] # in: in_0, in_1; out: 0009
            0009 leave # in: 0008
                # to: leaves
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
      assert_dfg(<<~DISASM, source)
        == dfg #<ISeq:<compiled>>
        block_0:
            0000 putobject                              10 # out: 0001
            0001 setlocal_WC_0                          n@0 # in: 0000
            0002 putobject_INT2FIX_0_ # out: 0003
            0003 setlocal_WC_0                          sum@1 # in: 0002
            0004 jump                                   label_28 (16)
                # to: block_16
        block_5:
            0005 putnil # out: 0006
            0006 pop # in: 0005
            0007 jump                                   label_28 (16)
                # to: block_16
        block_8: # from: block_16
            0008 getlocal_WC_0                          sum@1 # out: 0010
            0009 getlocal_WC_0                          n@0 # out: 0010
            0010 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr] # in: 0008, 0009; out: 0011
            0011 setlocal_WC_0                          sum@1 # in: 0010
            0012 getlocal_WC_0                          n@0 # out: 0014
            0013 putobject_INT2FIX_1_ # out: 0014
            0014 opt_minus                              <calldata!mid:-, argc:1, ARGS_SIMPLE>[CcCr] # in: 0012, 0013; out: 0015
            0015 setlocal_WC_0                          n@0 # in: 0014
                # to: block_16
        block_16: # from: block_0, block_5, block_8
            0016 getlocal_WC_0                          n@0 # out: 0018
            0017 putobject_INT2FIX_0_ # out: 0018
            0018 opt_gt                                 <calldata!mid:>, argc:1, ARGS_SIMPLE>[CcCr] # in: 0016, 0017; out: 0019
            0019 branchif                               label_13 (8) # in: 0018
                # to: block_8, block_20
        block_20: # from: block_16
            0020 putnil # out: 0021
            0021 pop # in: 0020
            0022 getlocal_WC_0                          sum@1 # out: 0023
            0023 leave # in: 0022
                # to: leaves
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
      assert_dfg(<<~DISASM, source)
        == dfg #<ISeq:<compiled>>
        block_0:
            0000 definemethod                           :fib, fib
            0001 putobject                              :fib # out: 0002
            0002 leave # in: 0001
                # to: leaves
        == dfg #<ISeq:fib>
        block_0:
            0000 getlocal_WC_0                          n@0 # out: 0002
            0001 putobject                              2 # out: 0002
            0002 opt_lt                                 <calldata!mid:<, argc:1, ARGS_SIMPLE>[CcCr] # in: 0000, 0001; out: 0003
            0003 branchunless                           label_11 (6) # in: 0002
                # to: block_6, block_4
        block_4: # from: block_0
            0004 getlocal_WC_0                          n@0 # out: 0005
            0005 leave # in: 0004
                # to: leaves
        block_6: # from: block_0
            0006 putself # out: 0010
            0007 getlocal_WC_0                          n@0 # out: 0009
            0008 putobject_INT2FIX_1_ # out: 0009
            0009 opt_minus                              <calldata!mid:-, argc:1, ARGS_SIMPLE>[CcCr] # in: 0007, 0008; out: 0010
            0010 opt_send_without_block                 <calldata!mid:fib, argc:1, FCALL|ARGS_SIMPLE> # in: 0006, 0009; out: 0016
            0011 putself # out: 0015
            0012 getlocal_WC_0                          n@0 # out: 0014
            0013 putobject                              2 # out: 0014
            0014 opt_minus                              <calldata!mid:-, argc:1, ARGS_SIMPLE>[CcCr] # in: 0012, 0013; out: 0015
            0015 opt_send_without_block                 <calldata!mid:fib, argc:1, FCALL|ARGS_SIMPLE> # in: 0011, 0014; out: 0016
            0016 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr] # in: 0010, 0015; out: 0017
            0017 leave # in: 0016
                # to: leaves
      DISASM
    end

    private

    def assert_dfg(expected, source)
      string = +""
      compiled = YARV.compile(source)
      compiled.all_iseqs.each do |iseq|
        cfg = YARV::CFG.new(iseq)
        dfg = YARV::DFG.new(cfg)
        string << dfg.disasm
      end
      assert_equal(expected, string)
    end
  end
end
