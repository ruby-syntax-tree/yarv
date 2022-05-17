# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `toregexp` is generated when string interpolation is used inside a regex
  # literal `//`. It pops a defined number of values from the stack, combines
  # them into a single string and coerces that string into a `Regexp` object,
  # which it pushes back onto the stack
  #
  # ### TracePoint
  #
  # `toregexp` cannot dispatch any TracePoint events.
  #
  # ### Usage
  #
  # ~~~ruby
  # "/#{true}/"
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,9)> (catch: FALSE)
  # # 0000 putobject                              ""                        (   1)[Li]
  # # 0002 putobject                              true
  # # 0004 dup
  # # 0005 objtostring                            <calldata!mid:to_s, argc:0, FCALL|ARGS_SIMPLE>
  # # 0007 anytostring
  # # 0008 toregexp                               0, 2
  # # 0011 leave
  # ~~~
  #
  class Toregexp
    attr_reader :opts, :cnt

    def initialize(opts, cnt)
      @opts = opts
      @cnt = cnt
    end

    def ==(other)
      other in Toregexp[opts: ^(opts), cnt: ^(cnt)]
    end

    def call(context)
      re_str = context.stack.pop(cnt).reverse.join
      context.stack.push(Regexp.new(re_str, opts))
    end

    def deconstruct_keys(keys)
      { opts:, cnt: }
    end

    def to_s
      "%-38s %s, %s" % ["toregexp", opts, cnt]
    end
  end
end
