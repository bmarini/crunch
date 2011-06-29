require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

task :default => [:test]

task :test do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.pattern = 'test/*_test.rb'
    t.verbose = true
  end
end
