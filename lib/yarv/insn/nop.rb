# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `nop` is a no-operation instruction. It is used to pad the instruction
  # sequence so there is a place for other instructions to jump to.
  #
  # ### TracePoint
  #
  # `nop` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # raise rescue true
  # ~~~
  #
  class Nop
    def ==(other)
      other in Nop
    end

    def call(context)
    end

    def to_s
      "%-38s %s" % ["nop"]
    end
  end
end
