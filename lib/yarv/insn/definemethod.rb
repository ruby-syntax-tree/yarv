# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `definemethod` defines a method on the class of the current value of `self`.
  # It accepts two arguments. The first is the name of the method being defined.
  # The second is the instruction sequence representing the body of the method.
  #
  # ### TracePoint
  #
  # `definemethod` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # def value = "value"
  # ~~~
  #
  class DefineMethod < Instruction
    attr_reader :name, :iseq

    def initialize(name, iseq)
      @name = name
      @iseq = iseq
    end

    def ==(other)
      other in DefineMethod[name: ^(name), iseq: ^(iseq)]
    end

    def call(context)
      context.define_method(context.current_iseq.selfo, name, iseq)
    end

    def deconstruct_keys(keys)
      { name:, iseq: }
    end

    def disasm(containing_iseq)
      "%-38s %s, %s" % ["definemethod", name.inspect, iseq.name]
    end
  end
end
