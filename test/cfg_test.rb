# frozen_string_literal: true

require "test_helper"

module YARV
  class CFGTest < Test::Unit::TestCase
    def test_branch
      assert_cfg(<<~DISASM, "foo ? 1 : 2")
        == cfg #<ISeq:<compiled>>
        block_0:
            0000 putself
            0001 opt_send_without_block                 <calldata!mid:foo, argc:0, FCALL|VCALL|ARGS_SIMPLE>
            0002 branchunless                           label_7 (5)
                # to: block_5, block_3
        block_3: # from: block_0
            0003 putobject_INT2FIX_1_
            0004 leave
                # to: leaves
        block_5: # from: block_0
            0005 putobject                              2
            0006 leave
                # to: leaves
      DISASM
    end

    def test_phi
      assert_cfg(<<~DISASM, "(n < 0 ? -1 : +1) + 100")
        == cfg #<ISeq:<compiled>>
        block_0:
            0000 putself
            0001 opt_send_without_block                 <calldata!mid:n, argc:0, FCALL|VCALL|ARGS_SIMPLE>
            0002 putobject_INT2FIX_0_
            0003 opt_lt                                 <calldata!mid:<, argc:1, ARGS_SIMPLE>[CcCr]
            0004 branchunless                           label_12 (7)
                # to: block_7, block_5
        block_5: # from: block_0
            0005 putobject                              -1
            0006 jump                                   label_13 (8)
                # to: block_8
        block_7: # from: block_0
            0007 putobject_INT2FIX_1_
                # to: block_8
        block_8: # from: block_5, block_7
            0008 putobject                              100
            0009 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr]
            0010 leave
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
      assert_cfg(<<~DISASM, source)
        == cfg #<ISeq:<compiled>>
        block_0:
            0000 putobject                              10
            0001 setlocal_WC_0                          n@0
            0002 putobject_INT2FIX_0_
            0003 setlocal_WC_0                          sum@1
            0004 jump                                   label_28 (16)
            0005 putnil
            0006 pop
            0007 jump                                   label_28 (16)
                # to: block_16
        block_8: # from: block_16
            0008 getlocal_WC_0                          sum@1
            0009 getlocal_WC_0                          n@0
            0010 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr]
            0011 setlocal_WC_0                          sum@1
            0012 getlocal_WC_0                          n@0
            0013 putobject_INT2FIX_1_
            0014 opt_minus                              <calldata!mid:-, argc:1, ARGS_SIMPLE>[CcCr]
            0015 setlocal_WC_0                          n@0
                # to: block_16
        block_16: # from: block_0, block_8
            0016 getlocal_WC_0                          n@0
            0017 putobject_INT2FIX_0_
            0018 opt_gt                                 <calldata!mid:>, argc:1, ARGS_SIMPLE>[CcCr]
            0019 branchif                               label_13 (8)
                # to: block_8, block_20
        block_20: # from: block_16
            0020 putnil
            0021 pop
            0022 getlocal_WC_0                          sum@1
            0023 leave
                # to: leaves
      DISASM
    end

    private

    def assert_cfg(expected, source)
      compiled = YARV.compile(source)
      cfg = YARV::CFG.new(compiled)
      assert_equal(expected, cfg.disasm)
    end
  end
end
