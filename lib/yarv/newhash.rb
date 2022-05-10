# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `newhash` puts a new hash onto the stack, using `num` elements from the
  # stack. `num` needs to be even.
  #
  # ### TracePoint
  #
  # `newhash` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # def foo(key, value)
  #   { key => value }
  # end
  #
  # # == disasm: #<ISeq:foo@-e:1 (1,0)-(3,3)> (catch: FALSE)
  # # local table (size: 2, argc: 2 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 2] key@0<Arg> [ 1] value@1<Arg>
  # # 0000 getlocal_WC_0                          key@0                     (   2)[LiCa]
  # # 0002 getlocal_WC_0                          value@1
  # # 0004 newhash                                2
  # # 0006 leave                                                            (   3)[Re]
  # ~~~
  #
  class NewHash
    def initialize(size)
      @size = size
    end

    def call(context)
      key_values = context.stack.pop(@size)
      context.stack.push(Hash[*key_values])
    end

    def pretty_print(q)
      q.text("newhash #{@size}")
    end
  end
end
