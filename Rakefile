# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

def only_test_or_dev
  yield if Rails.env.test? || Rails.env.development?
end

require File.expand_path('../config/application', __FILE__)

only_test_or_dev do
  require 'rspec/core/rake_task'
end

BoatValuator::Application.load_tasks

only_test_or_dev do
  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
end
