# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `getlocal` fetches the value of a local variable from a frame determined by
  # the level and index arguments. The level is the number of frames back to
  # look and the index is the index in the local table. It pushes the value it
  # finds onto the stack.
  #
  # ### TracePoint
  #
  # `getlocal` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # value = 5
  # tap { tap { value } }
  # ~~~
  #
  class GetLocal
    attr_reader :name, :index, :level

    def initialize(name, index, level)
      @name = name
      @index = index
      @level = level
    end

    def ==(other)
      other in GetLocal[name: ^(name), index: ^(index), level: ^(level)]
    end

    def call(context)
      value = context.parent_frame(level).get_local(index)
      context.stack.push(value)
    end

    def deconstruct_keys(keys)
      { name:, index:, level: }
    end

    def to_s
      "%-38s %s@%d, %d" % ["getlocal", name, index, level]
    end
  end
end
