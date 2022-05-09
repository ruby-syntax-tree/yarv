# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_nil_p` is an optimization applied when the method `nil?` is called. It
  # returns true immediately when the receiver is `nil` and defers to the `nil?`
  # method in other cases
  #
  # ### TracePoint
  #
  # `opt_nil_p` can dispatch `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "".nil?
  #
  # #== disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,9)> (catch: FALSE)
  # #0000 putstring                              ""                        (   1)[Li]
  # #0002 opt_nil_p                              <calldata!mid:nil?, argc:0, ARGS_SIMPLE>[CcCr]
  # #0004 leave
  # ~~~
  #
  class OptNilP
    def call(context)
      value = context.stack.pop

      result = context.call_method(value, :nil?, [])
      context.stack.push(result)
    end

    def pretty_print(q)
      q.text("opt_nil_p <calldata!mid:nil?, argc:0, ARGS_SIMPLE>")
    end
  end
end
