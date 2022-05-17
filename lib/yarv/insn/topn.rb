# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `topn` has one argument: `n`. It gets the nth element from the top of the
  # stack and pushes it on the stack.
  #
  # ### TracePoint
  #
  # `topn` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # case 3
  # when 1..5
  #   puts "foo"
  # end
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,36)> (catch: FALSE)
  # # 0000 putobject                              3                         (   1)[Li]
  # # 0002 putobject                              1..5
  # # 0004 topn                                   1
  # # 0006 opt_send_without_block                 <calldata!mid:===, argc:1, FCALL|ARGS_SIMPLE>
  # # 0008 branchif                               13
  # # 0010 pop
  # # 0011 putnil
  # # 0012 leave
  # # 0013 pop
  # # 0014 putself
  # # 0015 putstring                              "foo"
  # # 0017 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
  # # 0019 leave
  # ~~~
  #
  class TopN
    attr_reader :n

    def initialize(n)
      @n = n
    end

    def ==(other)
      other in TopN[n: ^(n)]
    end

    def call(context)
      value = context.stack[-n - 1]
      context.stack.push(value)
    end

    def deconstruct_keys(keys)
      { n: }
    end

    def to_s
      "%-38s %d" % ["topn", n]
    end
  end
end
