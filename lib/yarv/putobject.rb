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
  # ~~~
  #
  class PutObject
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def call(context)
      context.stack.push(object)
    end

    def to_s
      "%-38s %s" % ["putobject", object.inspect]
    end
  end
end
