# frozen_string_literal: true

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
  end
end
