# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_send_without_block` is a specialization of the send instruction that
  # occurs when a method is being called without a block.
  #
  # ### TracePoint
  #
  # `opt_send_without_block` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # puts "Hello, world!"
  # ~~~
  #
  class OptSendWithoutBlock
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def ==(other)
      other in OptSendWithoutBlock[call_data: ^(call_data)]
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
      "%-38s %s" % ["opt_send_without_block", call_data]
    end
  end
end
