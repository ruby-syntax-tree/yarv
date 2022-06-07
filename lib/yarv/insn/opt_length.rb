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
  # ~~~
  #
  class OptLength < Insn
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptLength[call_data: ^(call_data)]
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { call_data: }
    end

    def disasm(iseq)
      "%-38s %s%s" % ["opt_length", call_data, "[CcCr]"]
    end
  end
end
