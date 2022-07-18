# frozen_string_literal: true

require "test_helper"

module YARV
  class StaticSpecTest < Test::Unit::TestCase
    # We're not stupid, we just want to cache results from previous tests for
    # use in subsequent tests in COMPILED_CACHE, CFG_CACHE etc.
    self.test_order = :defined

    SPEC_FILES = ["#{__dir__}/../spec/ruby/language/and_spec.rb"]

    COMPILED_CACHE = {}
    CFG_CACHE = {}
    DFG_CACHE = {}
    SOY_CACHE = {}

    def test_compile
      SPEC_FILES.each do |spec_file|
        compiled =
          without_warnings do
            YARV.compile(
              File.read(spec_file),
              spec_file,
              File.basename(spec_file)
            )
          end
        COMPILED_CACHE[spec_file] = compiled
      end
    end

    def test_disasm
      SPEC_FILES.each do |spec_file|
        compiled = COMPILED_CACHE[spec_file]
        next unless compiled
        compiled.disasm
      end
    end

    def test_cfg
      SPEC_FILES.each do |spec_file|
        compiled = COMPILED_CACHE[spec_file]
        next unless compiled
        compiled.all_iseqs.each do |iseq|
          iseq_key = [spec_file, iseq.object_id]
          cfg = CFG.new(iseq)
          CFG_CACHE[iseq_key] = cfg
        end
      end
    end

    def test_cfg_disasm
      SPEC_FILES.each do |spec_file|
        compiled = COMPILED_CACHE[spec_file]
        next unless compiled
        compiled.all_iseqs.each do |iseq|
          iseq_key = [spec_file, iseq.object_id]
          cfg = CFG_CACHE[iseq_key]
          next unless cfg
          cfg.disasm
        end
      end
    end

    def test_dfg
      SPEC_FILES.each do |spec_file|
        compiled = COMPILED_CACHE[spec_file]
        next unless compiled
        compiled.all_iseqs.each do |iseq|
          iseq_key = [spec_file, iseq.object_id]
          cfg = CFG_CACHE[iseq_key]
          next unless cfg
          dfg = YARV::DFG.new(cfg)
          DFG_CACHE[iseq_key] = dfg
        end
      end
    end

    def test_dfg_disasm
      SPEC_FILES.each do |spec_file|
        compiled = COMPILED_CACHE[spec_file]
        next unless compiled
        compiled.all_iseqs.each do |iseq|
          iseq_key = [spec_file, iseq.object_id]
          dfg = DFG_CACHE[iseq_key]
          next unless dfg
          dfg.disasm
        end
      end
    end

    def test_soy
      SPEC_FILES.each do |spec_file|
        compiled = COMPILED_CACHE[spec_file]
        next unless compiled
        compiled.all_iseqs.each do |iseq|
          iseq_key = [spec_file, iseq.object_id]
          dfg = DFG_CACHE[iseq_key]
          next unless dfg
          soy = YARV::SOY.new(dfg)
          SOY_CACHE[iseq_key] = soy
        end
      end
    end

    def test_soy_mermaid
      SPEC_FILES.each do |spec_file|
        compiled = COMPILED_CACHE[spec_file]
        next unless compiled
        compiled.all_iseqs.each do |iseq|
          iseq_key = [spec_file, iseq.object_id]
          soy = SOY_CACHE[iseq_key]
          next unless soy
          soy.mermaid
        end
      end
    end

    def without_warnings
      original_verbose = $VERBOSE
      $VERBOSE = nil
      begin
        yield
      ensure
        $VERBOSE = original_verbose
      end
    end
  end
end
