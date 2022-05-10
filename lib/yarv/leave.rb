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
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,2)> (catch: FALSE)
  # # 0000 putnil
  # # 0001 leave
  # ~~~
  #
  class Leave
    def call(context)
      # skip for now
    end

    def to_s
      "leave"
    end
  end
end
