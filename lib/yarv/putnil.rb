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
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,3)> (catch: FALSE)
  # # 0000 putnil                                                           (   1)[Li]
  # # 0001 leave
  # ~~~
  #
  class PutNil
    def call(context)
      context.stack.push(nil)
    end

    def to_s
      "putnil"
    end
  end
end
