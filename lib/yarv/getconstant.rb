# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `getconstant` performs a constant lookup and pushes the value of the
  # constant onto the stack.
  #
  # ### TracePoint
  #
  # `getconstant` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # Constant
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,8)> (catch: FALSE)
  # # 0000 opt_getinlinecache                     9, <is:0>                 (   1)[Li]
  # # 0003 putobject                              true
  # # 0005 getconstant                            :Constant
  # # 0007 opt_setinlinecache                     <is:0>
  # # 0009 leave
  # ~~~
  #
  class GetConstant
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def call(context)
      klass, allow_nil = context.stack.pop(2)

      if klass.nil? && !allow_nil
        raise NameError, "uninitialized constant #{name}"
      end

      # At the moment we're just looking up constants in the parent runtime. In
      # the future, we'll want to look up constants in the YARV runtime as well.
      context.stack.push((klass || Object).const_get(name))
    end

    def to_s
      "%-38s %s" % ["getconstant", name.inspect]
    end
  end
end
