# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putnil` pushes a global nil object onto the stack.
  #
  # ### TracePoint
  #
  # `putnil` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # nil
  # ~~~
  #
  class PutNil < Instruction
    def ==(other)
      other in PutNil
    end

    def call(context)
      context.stack.push(nil)
    end

    def reads
      0
    end

    def writes
      1
    end

    def side_effects?
      false
    end

    def disasm(iseq)
      "putnil"
    end
  end
end
