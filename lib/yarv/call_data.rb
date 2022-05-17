# frozen_string_literal: true

module YARV
  # This class represents information about a specific call-site in the code.
  class CallData
    # stree-ignore
    FLAGS = [
      :ARGS_SPLAT,    # m(*args)
      :ARGS_BLOCKARG, # m(&block)
      :FCALL,         # m(...)
      :VCALL,         # m
      :ARGS_SIMPLE,   # (ci->flag & (SPLAT|BLOCKARG)) && blockiseq == NULL && ci->kw_arg == NULL
      :BLOCKISEQ,     # has blockiseq
      :KWARG,         # has kwarg
      :KW_SPLAT,      # m(**opts)
      :TAILCALL,      # located at tail position
      :SUPER,         # super
      :ZSUPER,        # zsuper
      :OPT_SEND,      # internal flag
      :KW_SPLAT_MUT   # kw splat hash can be modified (to avoid allocating a new one)
    ]

    attr_reader :mid, :argc, :flag

    def initialize(mid, argc, flag)
      @mid = mid
      @argc = argc
      @flag = flag
    end

    def ==(other)
      other in CallData[mid: ^(mid), argc: ^(argc), flag: ^(flag)]
    end

    def deconstruct_keys(keys)
      { mid:, argc:, flag: }
    end

    def to_s
      "<calldata!mid:#{mid}, argc:#{argc}, #{flags.join("|")}>"
    end

    private

    def flags
      FLAGS
        .each_with_index
        .each_with_object([]) do |(value, index), result|
          result << value if flag & (1 << index) != 0
        end
    end
  end
end
