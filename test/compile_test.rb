# frozen_string_literal: true

return unless ENV["CI"]
require_relative "test_helper"

module YARV
  class CompileTest < Test::Unit::TestCase
    Dir[File.join(RbConfig::CONFIG["libdir"], "**/*.rb")].each do |filepath|
      define_method(:"test_compile_#{filepath}") do
        YARV.compile(File.read(filepath), filepath, filepath)
      rescue SyntaxError
        # Skip past any files that have syntax errors.
      end
    end
  end
end
