# frozen_string_literal: true

$:.unshift(File.expand_path("../lib", __dir__))
require "yarv"
require "stringio"
require "test/unit"

module YARV
  class TestCase < Test::Unit::TestCase
    private

    def assert_insns(expected, code, **options)
      iseq = YARV.compile(code, **options)
      assert_equal(expected, iseq.insns.map(&:class))
    end

    def assert_stdout(expected, code, **options)
      original = $stdout
      $stdout = StringIO.new

      YARV.compile(code, **options).eval
      assert_equal(expected, $stdout.string)
    ensure
      $stdout = original
    end

    # Allows to test instructions sequences that the compiler doesn't generate.
    def assert_stdout_for_instructions(expected, instructions)
      original = $stdout
      $stdout = StringIO.new
      iseq = RubyVM::InstructionSequence.compile("").to_a
      iseq[-1] = [1, :RUBY_EVENT_LINE, *instructions, [:leave]]
      InstructionSequence.compile(Main.new, iseq).eval
      assert_equal(expected, $stdout.string)
    ensure
      $stdout = original
    end
  end
end
