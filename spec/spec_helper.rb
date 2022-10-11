# frozen_string_literal: true

require "bundler/setup"
require "magic_report"
require "pry"

I18n.load_path << Dir[File.expand_path("spec/support/locales") + "/*.yml"]
I18n.config.available_locales = :en

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
