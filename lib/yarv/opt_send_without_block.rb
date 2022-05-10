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
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def pretty_print(q)
      q.text(
        "opt_send_without_block <calldata!mid:#{mid}, argc:#{argc}, FCALL|ARGS_SIMPLE>"
      )
    end
  end
end
