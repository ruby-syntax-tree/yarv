# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_aref_with` is a specialization of the `opt_aref` instruction that
  # occurs when the `[]` operator is used with a string argument known at
  # compile time. In CRuby, there are fast paths if the receiver is a hash.
  #
  # ### TracePoint
  #
  # `opt_aref_with` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # { 'test' => true }['test']
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,26)> (catch: FALSE)
  # # 0000 duphash                                {"test"=>true}            (   1)[Li]
  # # 0002 opt_aref_with                          "test", <calldata!mid:[], argc:1, ARGS_SIMPLE>
  # # 0005 leave
  # ~~~
  #
  class OptArefWith
    attr_reader :key, :call_data

    def initialize(key, call_data)
      @key = key
      @call_data = call_data
    end

    def call(context)
      receiver = context.stack.pop
      result = context.call_method(call_data, receiver, [key])

      context.stack.push(result)
    end

    def to_s
      "%-38s %s, %s" % ["opt_aref_with", key, call_data]
    end
  end
end
