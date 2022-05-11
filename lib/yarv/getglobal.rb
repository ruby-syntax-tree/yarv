# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `getglobal` pushes the value of a global variables onto the stack.
  #
  # ### TracePoint
  #
  # `getglobal` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # $$
  #
  # ~~~
  #
  class GetGlobal
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def call(context)
      # If we're not currently tracking the global variable, then we're going to
      # steal the definition of it from the parent process by eval-ing it.
      if !context.globals.key?(name) && global_variables.include?(name)
        context.globals[name] = eval(name.to_s)
      end

      # If a global variable isn't defined for the given name, this is just
      # going to push `nil` onto the stack.
      context.stack.push(context.globals[name])
    end

    def to_s
      "%-38s %s" % ["getglobal", name.inspect]
    end
  end
end
