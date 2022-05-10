# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
end

task(default: %w[test syntax_tree:check])

namespace :syntax_tree do
  FILEPATHS = %w[Gemfile Rakefile lib/**/*.rb test/**/*.rb].freeze

  task :setup do
    $:.unshift File.expand_path("lib", __dir__)
    require "syntax_tree"
    require "syntax_tree/cli"
  end

  task check: :setup do
    exit SyntaxTree::CLI.run(["check"] + FILEPATHS)
  end

  task format: :setup do
    exit SyntaxTree::CLI.run(["write"] + FILEPATHS)
  end
end
