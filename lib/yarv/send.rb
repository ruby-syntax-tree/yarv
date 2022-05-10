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
      receiver, *arguments = context.stack.pop(argc + 1)
      result =
        context.call_method(receiver, mid, arguments) do
          block_iseq.eval(context)
        end

      context.stack.push(result)
    end

    def pretty_print(q)
      # q.text(
      #   "opt_send_without_block <calldata!mid:#{mid}, argc:#{argc}, FCALL|ARGS_SIMPLE>"
      # )
    end
  end
end
