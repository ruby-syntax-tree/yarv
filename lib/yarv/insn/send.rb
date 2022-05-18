# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `send` invokes a method with a block.
  #
  # ### TracePoint
  #
  # `send` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "hello".tap { |i| p i }
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,23)> (catch: FALSE)
  # # 0000 putstring                              "hello"                   (   1)[Li]
  # # 0002 send                                   <calldata!mid:tap, argc:0>, block in <main>
  # # 0005 leave
  # #
  # # == disasm: #<ISeq:block in <main>@-e:1 (1,12)-(1,23)> (catch: FALSE)
  # # local table (size: 1, argc: 1 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] i@0<Arg>
  # # 0000 putself                                                          (   1)[LiBc]
  # # 0001 getlocal_WC_0                          i@0
  # # 0003 opt_send_without_block                 <calldata!mid:p, argc:1, FCALL|ARGS_SIMPLE>
  # # 0005 leave                                  [Br]
  # # ~~~
  #
  class Send
    attr_reader :call_data, :block_iseq

    def initialize(call_data, block_iseq)
      @call_data = call_data
      @block_iseq = block_iseq
    end

    def ==(other)
      other in Send[call_data: ^(call_data), block_iseq: ^(block_iseq)]
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result =
        if block_iseq.nil?
          context.call_method(call_data, receiver, arguments)
        else
          context.call_method(call_data, receiver, arguments) do |*args|
            context.eval(block_iseq) do
              args.each_with_index do |arg, index|
                context.current_frame.locals[index] = arg
              end
            end
          end
        end

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { call_data:, block_iseq: }
    end

    def to_s
      "%-38s %s, %s" % ["send", call_data, block_iseq.name]
    end
  end
end
