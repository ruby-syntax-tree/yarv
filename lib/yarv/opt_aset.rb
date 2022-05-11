# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_aset` is an instruction for setting the hash value by the key in `recv[obj] = set` format
  #
  # ### TracePoint
  #
  #   # There is no trace point for `opt_aset`.
  #
  # ### Usage
  #
  # ~~~ruby
  # {}[:key] = 'val'
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,16)> (catch: FALSE)
  # # 0000 putnil                                                           (   1)[Li]
  # # 0001 newhash                                0
  # # 0003 putobject                              :key
  # # 0005 putstring                              "val"
  # # 0007 setn                                   3
  # # 0009 opt_aset                               <calldata!mid:[]=, argc:2, ARGS_SIMPLE>
  # # 0011 pop
  # # 0012 leave
  # ~~~
  #
  class OptAset
    attr_reader :call_data

    def initialize(call_data)
      @call_data = call_data
    end

    def call(context)
      receiver, *arguments = context.stack.pop(call_data.argc + 1)
      result = context.call_method(call_data, receiver, arguments)

      context.stack.push(result)
    end

    def to_s
      "%-38s %s%s" % ["opt_aset", call_data, "[CcCr]"]
    end
  end
end
