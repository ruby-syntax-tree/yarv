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
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,20)> (catch: FALSE)
  # # 0000 putself                                                          (   1)[Li]
  # # 0001 putstring                              "Hello, world!"
  # # 0003 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # # 0005 leave
  # ~~~
  #
  class OptSendWithoutBlock
    attr_reader :mid, :argc

    def initialize(mid, argc)
      @mid = mid
      @argc = argc
    end

    def execute(context)
      receiver, *arguments = context.stack.pop(argc + 1)
      context.stack.push(context.call_method(receiver, mid, arguments))
    end

    def pretty_print(q)
      q.text("opt_send_without_block <calldata!mid:#{mid}, argc:#{argc}, FCALL|ARGS_SIMPLE>")
    end
  end
end
