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
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def call(context)
      context.stack.push(value.dup)
    end

    def to_s
      "%-38s %s" % ["duparray", value.inspect]
    end
  end
end
