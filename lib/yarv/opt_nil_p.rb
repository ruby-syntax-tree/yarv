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
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,9)> (catch: FALSE)
  # # 0000 putstring                              ""                        (   1)[Li]
  # # 0002 opt_nil_p                              <calldata!mid:nil?, argc:0, ARGS_SIMPLE>[CcCr]
  # # 0004 leave
  # ~~~
  #
  class OptNilP
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def to_s
      "%-38s %s%s" % ["opt_nil_p", call_data, "[CcCr]"]
    end
  end
end
