# frozen_string_literal: true

require_relative "test_helper"

module YARV
  class VisitorTest < Test::Unit::TestCase
    def test_binary_plus
      assert_visit("2 + 3")
    end

    def test_binary_minus
      assert_visit("3 - 2")
    end

    def test_binary_mult
      assert_visit("2 * 3")
    end

    def test_binary_div
      assert_visit("3 / 2")
    end

    def test_call
      assert_visit("foo.bar")
    end

    def test_call_with_call
      assert_visit("foo.()")
    end

    def test_call_with_lonely
      assert_visit("foo&.bar")
    end

    def test_float
      assert_visit("1.0")
    end

    def test_gvar
      assert_visit("$foo")
    end

    def test_int
      assert_visit("3")
    end

    def test_int_0
      assert_visit("0")
    end

    def test_int_1
      assert_visit("1")
    end

    def test_paren
      assert_visit("(((0)))")
    end

    def test_rational
      assert_visit("1r")
    end

    def test_string_dvar_gvar
      assert_visit("\"\#$foo\"")
    end

    def test_string_literal
      assert_visit("\"foo \#{bar}\"")
    end

    def test_symbol_literal
      assert_visit(":foo")
    end

    def test_vcall
      assert_visit("foo")
    end

    def test_xstring_literal
      assert_visit("`foo`")
    end

    private

    def assert_visit(source)
      assert_equal(
        YARV.compile(source),
        Visitor.new.visit(SyntaxTree.parse(source))
      )
    end
  end
end
