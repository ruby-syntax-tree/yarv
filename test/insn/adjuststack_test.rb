# frozen_string_literal: true

require "test_helper"

module YARV
  class AdjustStackTest < TestCase
    def test_execute
      source = <<~RUBY
        x = [true]
        x[0] ||= nil
        x[0]
      RUBY

      YARV.compile(source).insns => [
        DupArray,
        SetLocalWC0,
        GetLocalWC0,
        PutObjectInt2Fix0,
        DupN,
        OptAref,
        Dup,
        BranchIf,
        Pop,
        PutNil,
        OptAset,
        Pop,
        Jump,
        AdjustStack[size: 3],
        GetLocalWC0,
        PutObjectInt2Fix0,
        OptAref,
        Leave
      ]
    end
  end
end
