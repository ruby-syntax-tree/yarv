# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_empty_p` is an optimization applied when the method `empty?` is called
  # on a String, Array or a Hash. This optimization can be applied because Ruby
  # knows how to calculate the length of these objects using internal C macros.
  #
  # ### TracePoint
  #
  # `opt_empty_p` can dispatch `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "".empty?
  #
  # #== disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,9)> (catch: FALSE)
  # #0000 putstring                              ""                        (   1)[Li]
  # #0002 opt_empty_p                            <calldata!mid:empty?, argc:0, ARGS_SIMPLE>[CcCr]
  # #0004 leave
  # ~~~
  #
  class OptEmptyP
    def call(context)
      value = context.stack.pop

      result = context.call_method(value, :empty?, [])
      context.stack.push(result)
    end

    def pretty_print(q)
      q.text("opt_empty_p <calldata!mid:empty?, argc:1, ARGS_SIMPLE>")
    end
  end
end
