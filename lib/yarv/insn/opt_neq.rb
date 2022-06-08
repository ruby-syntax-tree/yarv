module YARV
  # ### Summary
  #
  # `opt_neq` is an optimisation that tests whether two values at the top of
  # the stack are not equal by testing their equality and performing a logical
  # NOT on the result.
  #
  # This allows `opt_neq` to use the fast paths optimized in `opt_eq` when both
  # operands are Integers, Floats, Symbols or Strings.
  #
  #
  # ### TracePoint
  #
  # `opt_neq` can dispatch both the `c_call` and `c_return` events.
  #
  # ### Usage
  #
  # ~~~ruby
  # 2 != 2
  # ~~~
  #
  class OptNeq < Instruction
    attr_reader :cd_neq, :cd_eq

    def initialize(cd_eq, cd_neq)
      @cd_eq = cd_eq
      @cd_neq = cd_neq
    end

    def ==(other)
      other in OptNeq[cd_eq: ^(cd_eq), cd_neq: ^(cd_neq)]
    end

    def call(context)
      receiver, *arguments = context.stack.pop(cd_neq.argc + 1)
      result = context.call_method(cd_neq, receiver, arguments)

      context.stack.push(result)
    end

    def deconstruct_keys(keys)
      { cd_eq:, cd_neq: }
    end

    def disasm(iseq)
      "%-38s %s%s%s" % ["opt_neq", cd_eq, cd_neq, "[CcCr]"]
    end
  end
end
