require 'bundler'
Bundler::GemHelper.install_tasks

# RSpec Rails available via Appraisal
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task test: :spec
rescue LoadError
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'reek/rake/task'
Reek::Rake::Task.new

task default: %i[spec]
