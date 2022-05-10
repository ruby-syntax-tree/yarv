# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `duphash` pushes a hash onto the stack
  #
  # ### TracePoint
  #
  # `duphash` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # { a: 1 }
  #
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,8)> (catch: FALSE)
  # # 0000 duphash                                {:a=>1}                   (   1)[Li]
  # # 0002 leave
  # ~~~
  #
  class DupHash
    attr_reader :hash_object

    def initialize(hash_object)
      @hash_object = hash_object
    end

    def call(context)
      context.stack.push(hash_object.dup)
    end

    def pretty_print(q)
      q.text("dup_hash #{hash_object.inspect}")
    end
  end
end
