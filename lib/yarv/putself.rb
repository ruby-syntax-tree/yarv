# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putself` pushes the current value of self onto the stack.
  #
  # ### TracePoint
  #
  # `putself` can dispatch the line event.
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
  class PutSelf
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def execute(context)
      context.stack.push(object)
    end

    def pretty_print(q)
      q.text("putself")
    end
  end
end
