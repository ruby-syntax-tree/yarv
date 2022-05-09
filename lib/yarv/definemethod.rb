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
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,19)> (catch: FALSE)
  # # 0000 definemethod                           :value, value             (   1)[Li]
  # # 0003 putobject                              :value
  # # 0005 leave
  # #
  # # == disasm: #<ISeq:value@-e:1 (1,0)-(1,19)> (catch: FALSE)
  # # 0000 putstring                              "value"                   (   1)[Ca]
  # # 0002 leave                                  [Re]
  # ~~~
  #
  class DefineMethod
    attr_reader :name, :iseq

    def initialize(name, iseq)
      @name = name
      @iseq = iseq
    end

    def execute(context)
      context.define_method(context.current_iseq.selfo, name, iseq)
    end

    def pretty_print(q)
      q.text("definemethod #{name.inspect}")
    end
  end
end
