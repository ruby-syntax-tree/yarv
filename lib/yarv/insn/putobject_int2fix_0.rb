# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putobject_INT2FIX_0_` pushes 0 on the stack.
  # It is a specialized instruction resulting from the operand
  # unification optimization. It is the equivalent to `putobject 0`.
  #
  # ### TracePoint
  #
  # `putobject` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # 0
  # ~~~
  #
  class PutObjectInt2Fix0 < Instruction
    def ==(other)
      other in PutObjectInt2Fix0
    end

    def call(context)
      context.stack.push(0)
    end

    def reads
      0
    end

    def writes
      1
    end

    def disasm(iseq)
      "putobject_INT2FIX_0_"
    end
  end
end
