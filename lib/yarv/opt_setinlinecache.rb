# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `opt_setinlinecache` is the final instruction after a series of
  # `getconstant` instructions that populates the inline cache associated with
  # an `opt_getinlinecache` instruction.
  #
  # ### TracePoint
  #
  # `opt_setinlinecache` does not dispatch any events.
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
  class OptSetInlineCache
    attr_reader :cache

    def initialize(cache)
      @cache = cache
    end

    def execute(context)
      # Since we're not actually populating inline caches in YARV, we don't need
      # to do anything in this instruction.
    end

    def pretty_print(q)
      q.text("opt_setinlinecache")
    end
  end
end
