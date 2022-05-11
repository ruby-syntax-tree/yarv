# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `newrange` creates a Range. It takes one arguments, which is 0 if the end
  # is included or 1 if the end value is excluded.
  #
  # ### TracePoint
  #
  # `newrange` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # x = 0
  # y = 1
  # p (x..y), (x...y)
  #
  # # == disasm: #<ISeq:<main>@test.rb:1 (1,0)-(3,17)> (catch: FALSE)
  # # local table (size: 2, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 2] x@0        [ 1] y@1
  # # 0000 putobject_INT2FIX_0_                                             (   1)[Li]
  # # 0001 setlocal_WC_0                          x@0
  # # 0003 putobject_INT2FIX_1_                                             (   2)[Li]
  # # 0004 setlocal_WC_0                          y@1
  # # 0006 putself                                                          (   3)[Li]
  # # 0007 getlocal_WC_0                          x@0
  # # 0009 getlocal_WC_0                          y@1
  # # 0011 newrange                               0
  # # 0013 getlocal_WC_0                          x@0
  # # 0015 getlocal_WC_0                          y@1
  # # 0017 newrange                               1
  # # 0019 opt_send_without_block                 <calldata!mid:p, argc:2, FCALL|ARGS_SIMPLE>
  # # 0021 leave
  # ~~~
  #
  class NewRange
    def initialize(exclude_end)
      unless exclude_end == 0 || exclude_end == 1
        raise ArgumentError, "invalid exclude_end: #{exclude_end.inspect}"
      end
      @exclude_end = exclude_end
    end

    attr_reader :exclude_end

    def call(context)
      range_begin, range_end = context.stack.pop(2)
      context.stack.push(Range.new(range_begin, range_end, exclude_end == 1))
    end

    def to_s
      "%-38s %d" % ["newrange", exclude_end]
    end
  end
end
