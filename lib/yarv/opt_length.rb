# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_length` is a specialization of `opt_send_without_block`, when the
  # `length` method is called on a Ruby type with a known size. In CRuby there
  # are fast paths when the receiver is either a String, Hash or Array.
  #
  # ### TracePoint
  #
  # `opt_length` can dispatch `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "".length
  #
  # #== disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,9)> (catch: FALSE)
  # #0000 putstring                              ""                        (   1)[Li]
  # #0002 opt_length                             <calldata!mid:length, argc:0, ARGS_SIMPLE>[CcCr]
  # #0004 leave
  # ~~~
  #
  class OptLength
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def pretty_print(q)
      q.text("opt_length <calldata!mid:length, argc:0, ARGS_SIMPLE>")
    end
  end
end
