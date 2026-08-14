require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:web) do |t|
  t.pattern = 'spec/web/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:mobile) do |t|
  t.pattern = 'spec/mobile/**/*_spec.rb'
  # iOS runs against BrowserStack App Automate, a different backend/set of
  # credentials than the local-Appium Android suite - keep it out of the
  # general mobile run so `rake mobile` stays local-only. Run it via `rake
  # ios` instead.
  t.exclude_pattern = 'spec/mobile/ios_*_spec.rb'
end

RSpec::Core::RakeTask.new(:ios) do |t|
  t.pattern = 'spec/mobile/ios_*_spec.rb'
end

task default: :web
