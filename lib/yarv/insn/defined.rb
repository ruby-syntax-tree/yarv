# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `defined` checks if the top value of the stack is defined. If it is, it
  # pushes its value onto the stack. Otherwise it pushes `nil`.
  #
  # ### TracePoint
  #
  # `defined` cannot dispatch any TracePoint events.
  #
  # ### Usage
  #
  # ~~~ruby
  # defined?(x)
  # ~~~
  #
  class Defined
    DEFINED_TYPE = %i[
      DEFINED_NOT_DEFINED
      DEFINED_NIL
      DEFINED_IVAR
      DEFINED_LVAR
      DEFINED_GVAR
      DEFINED_CVAR
      DEFINED_CONST
      DEFINED_METHOD
      DEFINED_YIELD
      DEFINED_ZSUPER
      DEFINED_SELF
      DEFINED_TRUE
      DEFINED_FALSE
      DEFINED_ASGN
      DEFINED_EXPR
      DEFINED_REF
      DEFINED_FUNC
      DEFINED_CONST_FROM
    ]

    attr_reader :type, :object, :value

    def initialize(type, object, value)
      raise if type >= DEFINED_TYPE.length

      @type = type
      @object = object
      @value = value
    end

    def ==(other)
      other in Defined[type: ^(type), object: ^(object), value: ^(value)]
    end

    def call(context)
      predicate = context.stack.pop
      context.stack.push(vm_defined?(context, predicate) ? value : nil)
    end

    def to_s
      "%-38s %s, %s, %s" % ["defined", type, object.inspect, value.inspect]
    end

    private

    def vm_defined?(context, predicate)
      case DEFINED_TYPE[type]
      in :DEFINED_NOT_DEFINED
        raise "Compilation error"
      in :DEFINED_NIL
        true
      in :DEFINED_IVAR
        raise NotImplementedError, "defined?(ivar)"
      in :DEFINED_LVAR
        raise NotImplementedError, "defined?(lvar)"
      in :DEFINED_GVAR
        context.globals.key?(object)
      in :DEFINED_CVAR
        raise NotImplementedError, "defined?(cvar)"
      in :DEFINED_CONST
        raise NotImplementedError, "defined?(const)"
      in :DEFINED_METHOD
        raise NotImplementedError, "defined?(method)"
      in :DEFINED_YIELD
        raise NotImplementedError, "defined?(yield)"
      in :DEFINED_ZSUPER
        raise NotImplementedError, "defined?(zsuper)"
      in :DEFINED_SELF
        true
      in :DEFINED_TRUE
        true
      in :DEFINED_FALSE
        true
      in :DEFINED_ASGN
        raise NotImplementedError, "defined?(asgn)"
      in :DEFINED_EXPR
        raise NotImplementedError, "defined?(expr)"
      in :DEFINED_REF
        raise NotImplementedError, "defined?(ref)"
      in :DEFINED_FUNC
        raise NotImplementedError, "defined?(func)"
      in :DEFINED_CONST_FROM
        raise NotImplementedError, "defined?(const_from)"
      end
    end
  end
end
