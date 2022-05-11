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
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,6)> (catch: FALSE)
  # # 0000 putobject                              2                         (   1)[Li]
  # # 0002 putobject                              2
  # # 0004 opt_neq                                <calldata!mid:==, argc:1, ARGS_SIMPLE>, <calldata!mid:!=, argc:1, ARGS_SIMPLE>[CcCr]
  # # 0007 leave
  # ~~~
  #
  class OptNeq
    attr_reader :cd_neq, :cd_eq

    def initialize(cd_eq, cd_neq)
      @cd_eq = cd_eq
      @cd_neq = cd_neq
    end

    def call(context)
      receiver, *arguments = context.stack.pop(cd_neq.argc + 1)
      result = context.call_method(cd_neq, receiver, arguments)

      context.stack.push(result)
    end

    def to_s
      "%-38s %s%s%s" % ["opt_neq", cd_eq, cd_neq, "[CcCr]"]
    end
  end
end
