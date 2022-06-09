# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putobject` pushes a known value onto the stack.
  #
  # ### TracePoint
  #
  # `putobject` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # 5
  # ~~~
  #
  class PutObject < Instruction
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def ==(other)
      other in PutObject[object: ^(object)]
    end

    def call(context)
      context.stack.push(object)
    end

    def deconstruct_keys(keys)
      { object: }
    end

    def reads
      0
    end

    def writes
      1
    end

    def side_effects?
      false
    end

    def disasm(iseq)
      "%-38s %s" % ["putobject", object.inspect]
    end
  end
end
