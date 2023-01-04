# frozen_string_literal: true

require "test_helper"

module YARV
  class SetLocalTest < TestCase
    def test_execute
      YARV.compile("value = 5; tap { tap { value = 10 } }").insns => [
        PutObject,
        SetLocalWC0,
        PutSelf,
        Send[
          block_iseq: {
            insns: [
              PutSelf,
              Send[
                block_iseq: {
                  insns: [
                    PutObject,
                    Dup,
                    SetLocal[name: :value, level: 2],
                    Leave
                  ]
                }
              ],
              Leave
            ]
          }
        ],
        Leave
      ]
    end
  end
end
