require 'bundler/setup'
require 'rake/testtask'
load 'tasks/otr-activerecord.rake'

OTR::ActiveRecord.db_dir = 'db'
OTR::ActiveRecord.migrations_paths = ['db/migrate']

namespace :db do
  task :environment do
    require_relative 'config/app'
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end
