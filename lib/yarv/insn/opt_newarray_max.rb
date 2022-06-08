module YARV
  # ### Summary
  #
  # `opt_newarray_max` is an instruction that represents calling `max` on an
  # array literal. It is used to optimize quick comparisons of array elements.
  #
  # ### TracePoint
  #
  # `opt_newarray_max` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # [1, x = 2].max
  # ~~~
  #
  class OptNewArrayMax < Instruction
    attr_reader :size

    def initialize(size)
      @size = size
    end

    def ==(other)
      other in OptNewArrayMax[size: ^(size)]
    end

    def call(context)
      elements = context.stack.pop(size)
      call_data =
        CallData.new(:max, 0, 1 << CallData::FLAGS.index(:ARGS_SIMPLE))

      result = context.call_method(call_data, elements, [])
      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { size: }
    end

    def disasm(iseq)
      "%-38s %d" % ["opt_newarray_max", size]
    end
  end
end
