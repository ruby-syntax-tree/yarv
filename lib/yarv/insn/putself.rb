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
  # ~~~
  #
  class PutSelf < Insn
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def ==(other)
      other in PutSelf[object: ^(object)]
    end

    def call(context)
      context.stack.push(object)
    end

    def deconstruct_keys(keys)
      { object: }
    end

    def disasm(iseq)
      "putself"
    end
  end
end
