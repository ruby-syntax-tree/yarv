# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `newarray` puts a new array initialized with `size` values from the stack.
  #
  # ### TracePoint
  #
  # `newarray` dispatches a `line` event.
  #
  # ### Usage
  #
  # ~~~ruby
  # ["string"]
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,10)> (catch: FALSE)
  # # 0000 putstring                              "string"                  (   1)[Li]
  # # 0002 newarray                               1
  # # 0004 leave
  # ~~~
  class NewArray
    def initialize(size)
      @size = size
    end

    def call(context)
      array = context.stack.pop(@size)
      context.stack.push(array)
    end

    def pretty_print(q)
      q.text("newarray #{@size}")
    end
  end
end
