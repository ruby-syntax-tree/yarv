# frozen_string_literal: true

require "yarv"
require "stringio"
require "test/unit"

module YARV
  class TestCase < Test::Unit::TestCase
    private

    def assert_insns(expected, code)
      iseq = YARV.compile(code)
      assert_equal(expected, iseq.insns.map(&:class))
    end

    def assert_stdout(expected, code)
      original = $stdout
      $stdout = StringIO.new

      YARV.compile(code).eval
      assert_equal(expected, $stdout.string)
    ensure
      $stdout = original
    end
  end
end
