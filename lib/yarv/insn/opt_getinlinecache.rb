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
  # ~~~
  #
  class OptGetInlineCache < Instruction
    attr_reader :label, :cache

    def initialize(label, cache)
      @label = label
      @cache = cache
    end

    def ==(other)
      other in OptGetInlineCache[label: ^(label), cache: ^(cache)]
    end

    def call(context)
      # In CRuby, this is going to check if the cache is populated and then
      # potentially jump forward to the label. We're not going to track inline
      # caches in YARV, so we'll just always push nil onto the stack as if the
      # cache weren't yet populated.
      context.stack.push(nil)
    end

    def deconstruct_keys(keys)
      { label:, cache: }
    end

    def disasm(iseq)
      "%-38s %s, <is:%d>" %
        ["opt_getinlinecache", label["label_".length..], cache]
    end
  end
end
