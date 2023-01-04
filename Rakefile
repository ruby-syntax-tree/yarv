# frozen_string_literal: true

require "rake/testtask"
require "syntax_tree/rake_tasks"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end

source_files = FileList[%w[Gemfile Rakefile lib/**/*.rb test/**/*.rb]]
SyntaxTree::Rake::CheckTask.new(:"stree:check", source_files)
SyntaxTree::Rake::WriteTask.new(:"stree:write", source_files)

task default: :test
