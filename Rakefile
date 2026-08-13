require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:web) do |t|
  t.pattern = 'spec/web/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:mobile) do |t|
  t.pattern = 'spec/mobile/**/*_spec.rb'
end

task default: :web
