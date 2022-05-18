# frozen_string_literal: true

require "rake/testtask"
require "syntax_tree/rake_tasks"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
end

SOURCE_FILES = %w[Gemfile Rakefile lib/**/*.rb test/**/*.rb]
SyntaxTree::Rake::CheckTask.new(:"stree:check", SOURCE_FILES)
SyntaxTree::Rake::WriteTask.new(:"stree:write", SOURCE_FILES)

task(default: %w[test stree:check])
