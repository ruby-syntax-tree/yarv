# frozen_string_literal: true

module YARV
  # ### Summary
  #
  # `setlocal` instruction sets the value of a local variable on the
  # frame at a given depth below the current frame, determined by the depth
  # and the index given as its arguments.
  #
  # ### TracePoint
  #
  # `setlocal` does not dispatch any events.
  #
  # ### Usage
  #
  # ~~~ruby
  # value = 2
  # Proc.new do
  #   Proc.new do
  #     value = 5
  #   end
  # end
  #
  # # == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,46)> (catch: FALSE)
  # # local table (size: 1, argc: 0 [opts: 0, rest: -1, post: 0, block: -1, kw: -1@-1, kwrest: -1])
  # # [ 1] value@0
  # # 0000 putobject                              2                         (   1)[Li]
  # # 0002 setlocal_WC_0                          value@0
  # # 0004 opt_getinlinecache                     13, <is:0>
  # # 0007 putobject                              true
  # # 0009 getconstant                            :Proc
  # # 0011 opt_setinlinecache                     <is:0>
  # # 0013 send                                   <calldata!mid:new, argc:0>, block in <main>
  # # 0016 leave
  # #
  # # == disasm: #<ISeq:block in <main>@-e:1 (1,20)-(1,46)> (catch: FALSE)
  # # 0000 opt_getinlinecache                     9, <is:0>                 (   1)[LiBc]
  # # 0003 putobject                              true
  # # 0005 getconstant                            :Proc
  # # 0007 opt_setinlinecache                     <is:0>
  # # 0009 send                                   <calldata!mid:new, argc:0>, block (2 levels) in <main>
  # # 0012 leave                                  [Br]
  # #
  # # == disasm: #<ISeq:block (2 levels) in <main>@-e:1 (1,31)-(1,44)> (catch: FALSE)
  # # 0000 putobject                              5                         (   1)[LiBc]
  # # 0002 dup
  # # 0003 setlocal                               value@0, 2
  # # 0006 leave                                  [Br]
  # ~~~
  #
  class SetLocal
    attr_reader :name, :index, :depth

    def initialize(name, index, depth)
      @name = name
      @index = index
      @depth = depth
    end

    def call(context)
      frames = pop_frames_from_context

      value = context.stack.pop
      context.current_frame.set_local(index, value)

      push_frames_to_context(frames)
    end

    def to_s
      "%-38s %s@%d" % [instruction_name, name, index]
    end

    private

    def pop_frames_from_context
      depth.times.with_object([]) do |frame, frames|
        frames << context.frames.pop
      end
    end

    def push_frames_to_context(frames)
      frames.each do |frame|
        context.frames.push(frame)
      end
    end

    def instruction_name
      "setlocal"
    end
  end
end
