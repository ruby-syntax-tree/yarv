# frozen_string_literal: true

require_relative "./test_case"

module YARV
  class JumpTest < TestCase
    def test_jump_moves_the_control_flow
      source_code = "y = 0; if y == 0 then puts '0' else puts '2' end"
      assert_stdout("0\n", source_code, peephole_optimization: false)
    end
  end
end
