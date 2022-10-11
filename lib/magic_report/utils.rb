# frozen_string_literal: true

module MagicReport
  module Utils
    def underscore(klass)
      klass.gsub(/::/, "/")
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr("-", "_")
        .downcase
    end

    def derive_class(opts, &block)
      if block
        raise "name option must be provided" unless opts[:name]

        cloned_klass = ::MagicReport::Report.clone
        cloned_klass.class_eval(&block)
        cloned_klass
      else
        opts[:class]
      end
    end

    # @param name is the report name
    # @key is a field
    def t(name:, key:)
      I18n.translate!("magic_report.headings.#{name}.#{key}")
    end

    module_function :underscore
    module_function :derive_class
    module_function :t
  end
end
