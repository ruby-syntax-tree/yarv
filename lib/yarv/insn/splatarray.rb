# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `splatarray` calls to_a on an array to splat.
  #
  # It coerces the array object at the top of the stack into Array by calling
  # `to_a`. It pushes a duplicate of the array if there is a flag, and the original
  # array, if there isn't one.
  #
  # ### TracePoint
  #
  # `splayarray` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # x = *(5)
  # ~~~
  #
  class SplatArray < Instruction
    attr_reader :flag

    def initialize(flag)
      @flag = flag
    end

    def ==(other)
      other in SplatArray
    end

    def call(context)
      array = coerce(context.stack.pop)
      final_array = flag ? array.dup : array
      context.stack.push(final_array)
    end

    def disasm(iseq)
      "splatarray"
    end

    private

    def coerce(object)
      object.respond_to?(:to_a) ? object.to_a : [object]
    end
  end
end
