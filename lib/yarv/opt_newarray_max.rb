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
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,14)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] x@0
  # # 0000 putobject_INT2FIX_1_                                             (   1)[Li]
  # # 0001 putobject                              2
  # # 0003 dup
  # # 0004 setlocal_WC_0                          x@0
  # # 0006 opt_newarray_max                       2
  # # 0008 leave
  # ~~~
  #
  class OptNewArrayMax
    attr_reader :size

    def initialize(size)
      @size = size
    end

    def call(context)
      elements = context.stack.pop(size)
      call_data =
        CallData.new(:max, 0, 1 << CallData::FLAGS.index(:ARGS_SIMPLE))

      result = context.call_method(call_data, elements, [])
      context.stack.push(result)
    end

    def to_s
      "%-38s %d" % ["opt_newarray_max", size]
    end
  end
end
