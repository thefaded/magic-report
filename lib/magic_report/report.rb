# frozen_string_literal: true

module MagicReport
  class Report
    include ClassHelpers

    attr_reader :fields, :has_one, :has_many, :name, :nested_field, :prefix, :result

    def initialize(fields: nil, has_one: nil, has_many: nil, name: nil, prefix: nil, nested_field: nil)
      @fields = fields || fields_from_class
      @has_one = has_one || has_one_from_class
      @has_many = has_many || has_many_from_class
      @name = name || name_from_class

      @prefix = prefix
      @nested_field = nested_field
    end

    def process(input)
      @result = ::MagicReport::Report::Process.new(self).call(input)
    end

    def as_csv
      @as_csv ||= begin
        csv = ::MagicReport::Report::Csv.new(self)
        csv.generate

        csv
      end
    end

    def headings
      @headings ||= (fields.map { |field| t(field.key) } + has_one.map { |association| association.report.headings } + has_many.map { |association| association.report.headings }).flatten
    end

    class << self
      def t(key)
        ::MagicReport::Utils.t(name: name, key: key)
      end

      def fields(*attrs)
        @fields ||= []

        Types::SymbolArray[attrs].each do |key|
          @fields << Configuration::Field.new(key: key)
        end
      end

      def field(*attrs)
        key, processor = attrs

        @fields ||= []
        @fields << Configuration::Field.new(key: key, processor: processor)
      end

      def has_one(attribute, opts = {}, &block)
        @has_one ||= []

        coerced_attribute = Types::Coercible::Symbol[attribute]

        klass = ::MagicReport::Utils.derive_class(opts, &block)

        if (prefix = opts[:prefix])
          opts[:prefix] = new.instance_exec(&prefix)
        end

        @has_one << Configuration::HasOne.new(klass: klass, opts: opts, key: coerced_attribute)
      end

      def has_many(attribute, opts = {}, &block)
        @has_many ||= []

        coerced_attribute = Types::Coercible::Symbol[attribute]

        klass = ::MagicReport::Utils.derive_class(opts, &block)

        if (prefix = opts[:prefix])
          opts[:prefix] = new.instance_exec(&prefix)
        end

        @has_many << Configuration::HasMany.new(klass: klass, opts: opts, key: coerced_attribute)
      end
    end

    def resolve_path(key)
      nested_field ? "#{nested_field}.#{key}".to_sym : key
    end

    private

    def t(key)
      translated = ::MagicReport::Utils.t(name: name, key: key)

      prefix ? "#{prefix} #{translated}" : translated
    end
  end
end
