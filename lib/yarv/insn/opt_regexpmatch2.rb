# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_regexpmatch2` is a specialization of the `opt_send_without_block`
  # instruction that occurs when the `=~` operator is used.
  #
  # ### TracePoint
  #
  # `opt_regexpmatch2` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # /a/ =~ "a"
  # ~~~
  #
  class OptRegexpMatch2 < Instruction
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptRegexpMatch2[call_data: ^(call_data)]
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
      "%-38s %s%s" % ["opt_regexpmatch2", call_data, "[CcCr]"]
    end
  end
end
