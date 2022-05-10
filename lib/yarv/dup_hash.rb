# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `duphash` pushes a hash onto the stack
  #
  # ### TracePoint
  #
  # `duphash` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # { a: 1 }
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,8)> (catch: FALSE)
  # # 0000 duphash                                {:a=>1}                   (   1)[Li]
  # # 0002 leave
  # ~~~
  #
  class DupHash
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def call(context)
      context.stack.push(value.dup)
    end

    def to_s
      "%-38s %s" % ["duphash", value.inspect]
    end
  end
end
