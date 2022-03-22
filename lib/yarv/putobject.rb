# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putobject` pushes a known value onto the stack.
  #
  # ### TracePoint
  #
  # `putobject` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # 5
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,1)> (catch: FALSE)
  # # 0000 putobject                              5                         (   1)[Li]
  # # 0002 leave
  # ~~~
  #
  class PutObject
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def execute(stack)
      stack.push(object)
    end

    def pretty_print(q)
      q.text("putobject #{object.inspect}")
    end
  end
end
