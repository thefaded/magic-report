# frozen_string_literal: true

require "dry-types"
require "i18n"

require "magic_report/version"

module MagicReport
  class Error < StandardError; end

  module Types
    include ::Dry.Types()

    SymbolArray = Array.of(Types::Coercible::Symbol)
  end

  require "magic_report/utils"

  require "magic_report/report/class_helpers"
  require "magic_report/report/configuration"
  require "magic_report/report/process"
  require "magic_report/report/row"
  require "magic_report/report/csv"
  require "magic_report/report"
end
