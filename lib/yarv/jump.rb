# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `jump` has one argument, the jump index, which it uses to set the next
  # instruction to execute.
  #
  # ### TracePoint
  #
  # There is no trace point for `jump`.
  #
  # ### Usage
  #
  # ~~~ruby
  # y = 0
  # if y == 0
  #   puts "0"
  # else
  #   puts "2"
  # end
  #
  # ~~~
  #
  class Jump
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def call(context)
      jump_index = context.current_iseq.labels[label]
      context.program_counter = jump_index
    end

    def to_s
      "%-38s %s" % ["jump", label["label_".length..]]
    end
  end
end
