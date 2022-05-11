# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `concatstrings` just pops a number of strings from the stack joins them together
  # into a single string and pushes that string back on the stack.
  #
  # This does no coercion and so is always used in conjunction with `objtostring`
  # and `anytostring` to ensure the stack contents are always strings
  #
  # ### TracePoint
  #
  # `concatstrings` can dispatch the `line` and `call` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "#{5}"
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,6)> (catch: FALSE)
  # # 0000 putobject                              ""                        (   1)[Li]
  # # 0002 putobject                              5
  # # 0004 dup
  # # 0005 objtostring                            <calldata!mid:to_s, argc:0, FCALL|ARGS_SIMPLE>
  # # 0007 anytostring
  # # 0008 concatstrings                          2
  # # 0010 leave
  # ~~~
  #
  class ConcatStrings
    attr_reader :num

    def initialize(num)
      @num = num
    end

    def call(context)
      strings = context.stack.pop(num)
      context.stack.push(strings.join)
    end

    def to_s
      "%-38s %s" % ["concatstrings", num]
    end
  end
end
