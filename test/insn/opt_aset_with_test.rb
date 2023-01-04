# frozen_string_literal: true

require "test_helper"

module YARV
  class OptAsetWithTest < TestCase
    def test_execute
      YARV.compile("{}[\"true\"] = true").insns => [
        NewHash,
        PutObject,
        Swap,
        TopN,
        OptAsetWith[key: "true"],
        Pop,
        Leave
      ]
    end
  end
end
