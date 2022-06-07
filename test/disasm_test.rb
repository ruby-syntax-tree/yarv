# frozen_string_literal: true

require "test_helper"

module YARV
  class DisasmTest < Test::Unit::TestCase
    def test_binary_plus
      assert_disasm(<<~DISASM, "2 + 3")
        == disasm #<ISeq:<compiled>> (catch: FALSE)
        0000 putobject                              2
        0001 putobject                              3
        0002 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr]
        0003 leave
      DISASM
    end

    def test_branch_plus
      assert_disasm(<<~DISASM, "foo ? 1 : 2")
        == disasm #<ISeq:<compiled>> (catch: FALSE)
        0000 putself
        0001 opt_send_without_block                 <calldata!mid:foo, argc:0, FCALL|VCALL|ARGS_SIMPLE>
        0002 branchunless                           label_7 (5)
        0003 putobject_INT2FIX_1_
        0004 leave
        0005 putobject                              2
        0006 leave
      DISASM
    end

    private

    def assert_disasm(expected, source)
      assert_equal(expected, YARV.compile(source).disasm)
    end
  end
end
