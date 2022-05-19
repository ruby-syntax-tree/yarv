# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_aset_with` is an instruction for setting the hash value by the known
  # string key in the `recv[obj] = set` format.
  #
  # ### TracePoint
  #
  # There is no trace point for `opt_aset_with`.
  #
  # ### Usage
  #
  # ~~~ruby
  # {}["key"] = value
  # ~~~
  #
  class OptAsetWith
    attr_reader :key, :call_data

    def initialize(key, call_data)
      @key = key
      @call_data = call_data
    end

    def ==(other)
      other in OptAsetWith[key: ^(key), call_data: ^(call_data)]
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc)
      result = context.call_method(call_data, receiver, [key, *arguments])

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { key:, call_data: }
    end

    def to_s
      "%-38s %s, %s" % ["opt_aset_with", key.inspect, call_data]
    end
  end
end
