# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `send`
  #
  # ### TracePoint
  #
  # `send`
  #
  # ### Usage
  #
  # ~~~ruby
  #
  #
  # ~~~
  #
  class Send
    attr_reader :mid, :argc, :block_iseq

    def initialize(mid, argc, block_iseq)
      @mid = mid
      @argc = argc
      @block_iseq = block_iseq
    end

    def call(context)
      block = proc { block_iseq.eval(context) }
      receiver, *arguments = context.stack.pop(argc + 1)
      context.stack.push(context.call_method(receiver, mid, arguments, &block))
    end

    def pretty_print(q)
      # q.text(
      #   "opt_send_without_block <calldata!mid:#{mid}, argc:#{argc}, FCALL|ARGS_SIMPLE>"
      # )
    end
  end
end
