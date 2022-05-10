# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_aset` is an instruction for `recv[obj] = set` format # TODO expand me
  #
  # ### TracePoint
  #
  # TODO
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
  class OptAset
    def call(context)
      left, middle, right = context.stack.pop(3)

      result = context.call_method(left, :[]=, [middle, right])
      context.stack.push(result)
    end

    def pretty_print(q)
      q.text('opt_aset <calldata!mid:[]=, argc:2, ARGS_SIMPLE>')
    end
  end
end
