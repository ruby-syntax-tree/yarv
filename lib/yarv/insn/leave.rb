# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `leave` exits the current frame.
  #
  # ### TracePoint
  #
  # `leave` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # ;;
  # ~~~
  #
  class Leave < Insn
    def ==(other)
      other in Leave
    end

    def call(context)
      # skip for now
    end

    def disasm(iseq)
      "leave"
    end
  end
end
