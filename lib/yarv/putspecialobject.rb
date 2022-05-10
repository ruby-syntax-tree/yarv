# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `putspecialobject` is an instruction that pushes an object representing a
  # scope onto the stack. This scope is used by the instructions that follow.
  #
  #  The value passed to `putspecialobject` corresponds to the enum members of
  #  `vm_special_object_type`. They are:
  #
  # - 1. `VM_SPECIAL_OBJECT_VMCORE`. This is an object created at the start of
  #      VM initialization that defines some basic functionality.
  # - 2. `VM_SPECIAL_OBJECT_CBASE`.
  # - 3. `VM_SPECIAL_OBJECT_CONST_BASE`. 
  # ### TracePoint
  #
  # `putspecialobject` can dispatch the line event.
  #
  # ### Usage
  #
  # ~~~ruby
  # alias :foobar :!
  #
  # #== disasm: #<ISeq:<main>@-e:1 (1,0)-(1,14)> (catch: FALSE)
  # #0000 putspecialobject                       3                         (   1)[Li]
  # #0002 putnil
  # #0003 defineclass                            :Foo, <class:Foo>, 0
  # #0007 leave
  # #
  # #== disasm: #<ISeq:<class:Foo>@-e:1 (1,0)-(1,14)> (catch: FALSE)
  # #0000 putnil                                                           (   1)[Cl]
  # #0001 leave    
  # ~~~
  #
  class PutSpecialObject
    attr_reader :type

    def initialize(type)
      @object = type
    end

    def call(context)
      if type == 3 
        context.stack.push(context.current_frame)
      end
    end

    def pretty_print(q)
      q.text("putobject #{object.inspect}")
    end
  end
end