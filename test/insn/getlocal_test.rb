# frozen_string_literal: true

require "test_helper"

module YARV
  class GetLocalTest < TestCase
    def test_execute
      YARV.compile("value = 5; tap { tap { value } }").insns =>
        [PutObject,
        SetLocalWC0,
        PutSelf,
        Send[
          block_iseq: {
            insns: [PutSelf,
            Send[
              block_iseq: { insns: [GetLocal[name: :value, level: 2], Leave] }
            ],
            Leave]
          }
        ],
        Leave]
    end
  end
end
