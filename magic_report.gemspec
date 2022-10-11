# frozen_string_literal: true

require_relative "lib/magic_report/version"

Gem::Specification.new do |spec|
  spec.name = "magic-report"
  spec.version = MagicReport::VERSION
  spec.summary = "An easy way to export data to CSV"
  spec.homepage = "https://github.com/thefaded/magic-report"
  spec.license = "MIT"

  spec.author = "Dan Pankratev"
  spec.email = "thepoddubstep@gmail.com"

  spec.files = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path = "lib"

  spec.required_ruby_version = ">= 2.6"

  spec.add_runtime_dependency "dry-types"

  spec.add_development_dependency "i18n"
end
