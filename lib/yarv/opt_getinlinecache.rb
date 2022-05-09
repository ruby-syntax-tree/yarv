# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_getinlinecache` is a wrapper around a series of `getconstant`
  # instructions that allows skipping past them if the inline cache is currently
  # set.
  #
  # ### TracePoint
  #
  # `opt_getinlinecache` does not dispatch any events.
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
  class OptGetInlineCache
    attr_reader :label, :cache

    def initialize(label, cache)
      @label = label
      @cache = cache
    end

    def call(context)
      # In CRuby, this is going to check if the cache is populated and then
      # potentially jump forward to the label. We're not going to track inline
      # caches in YARV, so we'll just always push nil onto the stack as if the
      # cache weren't yet populated.
      context.stack.push(nil)
    end

    def pretty_print(q)
      q.text("opt_getinlinecache")
    end
  end
end
