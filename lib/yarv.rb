# frozen_string_literal: true

require_relative "yarv/leave"
require_relative "yarv/opt_minus"
require_relative "yarv/opt_plus"
require_relative "yarv/opt_send_without_block"
require_relative "yarv/opt_str_uminus"
require_relative "yarv/putobject"
require_relative "yarv/putself"

module YARV
  Main = Object.new

  class InstructionSequence
    attr_reader :selfo, :insns

    def initialize(selfo, insns)
      @selfo = selfo
      @insns =
        insns.filter_map do |insn|
          case insn
          in Integer | :RUBY_EVENT_LINE
            # skip for now
          in [:leave]
            Leave.new
          in [:opt_minus, { mid: :-, orig_argc: 1 }]
            OptMinus.new
          in [:opt_plus, { mid: :+,  orig_argc: 1 }]
            OptPlus.new
          in [:opt_send_without_block, { mid:, orig_argc: }]
            OptSendWithoutBlock.new(mid, orig_argc)
          in [:opt_str_uminus, value, { mid: :-@, orig_argc: 0 }]
            OptStrUMinus.new(value)
          in [:putobject, object]
            PutObject.new(object)
          in [:putself]
            PutSelf.new(selfo)
          end
        end
    end

    def emulate
      stack = []
      insns.each { |insn| insn.execute(stack) }
    end
  end

  def self.compile(source)
    iseq = RubyVM::InstructionSequence.compile(source, specialized_instruction: true)
    InstructionSequence.new(Main, iseq.to_a.last)
  end

  def self.emulate(source)
    compile(source).emulate
  end
end
