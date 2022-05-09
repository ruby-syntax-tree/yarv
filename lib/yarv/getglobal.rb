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
  # # == disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,2)> (catch: FALSE)
  # # 0000 getglobal                              :$$                       (   1)[Li]    
  # # 0002 leave  
  # ~~~
  #
  class GetGlobal
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def execute(context)
      # If we're not currently tracking the global variable, then we're going to
      # steal the definition of it from the parent process by eval-ing it.
      if !context.globals.key?(name) && global_variables.include?(name)
        context.globals[name] = eval(name.to_s)
      end

      # If a global variable isn't defined for the given name, this is just
      # going to push `nil` onto the stack.
      context.stack.push(context.globals[name])
    end

    def pretty_print(q)
      q.text("getglobal #{name.inspect}")
    end
  end
end
