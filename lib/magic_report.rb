# frozen_string_literal: true

require "dry-types"
require "i18n"

require "active_support"
require "active_support/core_ext/class/attribute"
require "active_support/inflector"

require "magic_report/version"

module MagicReport
  class Error < StandardError; end

  module Types
    include ::Dry.Types()

    SymbolArray = Array.of(Types::Coercible::Symbol)
  end

  require "magic_report/report/builder/field"
  require "magic_report/report/builder/has_one"
  require "magic_report/report/builder/has_many"

  require "magic_report/report/reflection"
  require "magic_report/report/row"
  require "magic_report/report/csv"
  require "magic_report/report"
end
