module YARV
  # ### Summary
  #
  # `setn` is an instruction for set Nth stack entry to stack top
  #
  # ### TracePoint
  #
  #  # `setn` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # {}[:key] = 'val'
  #
  # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,16)> (catch: FALSE)
  # 0000 putnil                                                           (   1)[Li]
  # 0001 newhash                                0
  # 0003 putobject                              :key
  # 0005 putstring                              "val"
  # 0007 setn                                   3
  # 0009 opt_aset                               <calldata!mid:[]=, argc:2, ARGS_SIMPLE>
  # 0011 pop
  # 0012 leave
  # ~~~
  #
  class Setn
    attr_reader :index

    def initialize(index)
      @index = index
    end

    def call(context)
      context.stack[-index - 1] = context.stack.last
    end

    def to_s
      "%-38s %s" % ["setn", index]
    end
  end
end
