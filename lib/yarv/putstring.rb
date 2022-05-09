# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putstring` pushes a string literal onto the stack.
  #
  # ### TracePoint
  #
  # `putstring` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # "foo"
  #
  #== disasm: #<ISeq:<compiled>@<compiled>:1 (1,0)-(1,5)> (catch: FALSE)
  #0000 putstring                              "foo"                     (   1)[Li]                                  
  #0002 leave 
  # ~~~
  #
  class PutString
    attr_reader :string

    def initialize(string)
      @string = string
    end

    def call(context)
      context.stack.push(string)
    end

    def pretty_print(q)
      q.text("putstring #{object.inspect}")
    end
  end
end
