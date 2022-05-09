# frozen_string_literal: true

$:.unshift(File.expand_path("../lib", __dir__))
require "yarv/opt_plus"

require_relative "./yarv_test"

class OptPlusTest < YARVTest
  def test_opt_plus
    assert_insns([YARV::PutObject, YARV::PutObject, YARV::OptPlus, YARV::Leave], "2 + 3")
    assert_stdout("5\n", "p 2 + 3")
  end
end
