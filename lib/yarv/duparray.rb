# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `duparray` copies a literal Array and pushes it onto the stack.
  #
  # ### TracePoint
  #
  # `duparray` can dispatch the `line` event.
  #
  # ### Usage
  #
  # ~~~ruby
  # [true]
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,6)> (catch: FALSE)
  # # 0000 duparray                               [true]                    (   1)[Li]
  # # 0002 leave
  # ~~~
  #
  class DupArray
    def initialize(array)
      @array = array
    end

    def call(context)
      context.stack.push(@array.dup)
    end
  end
end
