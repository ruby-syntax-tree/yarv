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
  class Leave
    def call(context)
      # skip for now
    end

    def to_s
      "leave"
    end
  end
end
