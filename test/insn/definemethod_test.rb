# frozen_string_literal: true

require "test_helper"

module YARV
  class DefineMethodTest < TestCase
    def test_execute
      source = <<~SOURCE
        def value = "value"
        puts value
      SOURCE

      assert_insns(
        [
          DefineMethod,
          PutSelf,
          PutSelf,
          OptSendWithoutBlock,
          OptSendWithoutBlock,
          Leave
        ],
        source
      )
      assert_stdout("value\n", source)
    end

    def test_execute_with_leading_arguments
      source = <<~SOURCE
        def echo(value) = value
        puts echo(1)
      SOURCE

      assert_stdout("1\n", source)
    end

    def test_execute_with_leading_argument_and_other_locals
      source = <<~SOURCE
        def add2(value)
          addition = 2
          addition + value
        end

        puts add2(1)
      SOURCE

      assert_stdout("3\n", source)
    end

    def test_execute_with_leading_arguments_and_other_locals
      source = <<~SOURCE
        def add3(left, right)
          addition = 2
          addition + left + right
        end

        puts add3(3, 4)
      SOURCE

      assert_stdout("9\n", source)
    end
  end
end
