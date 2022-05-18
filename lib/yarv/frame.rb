# frozen_string_literal: true

module YARV
  # This represents an execution frame.
  class Frame
    UNDEFINED = Object.new

    attr_reader :iseq, :locals

    def initialize(iseq)
      @iseq = iseq
      @locals = Array.new(iseq.locals.length) { UNDEFINED }
    end

    # Fetches the value of a local variable from the frame. If the value has
    # not yet been initialized, it will raise an error.
    def get_local(index)
      local = locals[index]
      if local == UNDEFINED
        raise NameError,
              "undefined local variable or method `#{iseq.locals[index]}' for #{iseq.selfo}"
      end

      local
    end

    # Sets the value of the local variable on the frame.
    def set_local(index, value)
      @locals[index] = value
    end
  end
end
