# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `setlocal` sets the value of a local variable on a frame determined by the
  # level and index arguments. The level is the number of frames back to
  # look and the index is the index in the local table. It pops the value it is
  # setting off the stack.
  #
  # ### TracePoint
  #
  # `setlocal` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # value = 5
  # tap { tap { value = 10 } }
  # ~~~
  #
  class SetLocal
    attr_reader :name, :index, :level

    def initialize(name, index, level)
      @name = name
      @index = index
      @level = level
    end

    def ==(other)
      other in SetLocal[name: ^(name), index: ^(index), level: ^(level)]
    end

    def call(context)
      value = context.stack.pop
      context.parent_frame(level).set_local(index, value)
    end

    def deconstruct_keys(keys)
      { name:, index:, level: }
    end

    def to_s
      "%-38s %s@%d, %d" % ["setlocal", name, index, level]
    end
  end
end
