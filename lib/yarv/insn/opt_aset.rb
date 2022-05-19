# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_aset` is an instruction for setting the hash value by the key in `recv[obj] = set` format
  #
  # ### TracePoint
  #
  # There is no trace point for `opt_aset`.
  #
  # ### Usage
  #
  # ~~~ruby
  # {}[:key] = value
  # ~~~
  #
  class OptAset
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptAset[call_data: ^(call_data)]
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { call_data: }
    end

    def to_s
      "%-38s %s%s" % ["opt_aset", call_data, "[CcCr]"]
    end
  end
end
