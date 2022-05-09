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
    def call(context)
      value = context.stack.pop

      result = context.call_method(value, :length, [])
      context.stack.push(result)
    end

    def pretty_print(q)
      q.text("opt_length <calldata!mid:length, argc:0, ARGS_SIMPLE>")
    end
  end
end
