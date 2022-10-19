# frozen_string_literal: true

module MagicReport
  class Report
    include Reflection

    attr_reader :model, :row

    def initialize(model, row = nil)
      @model = model
      @row = row || self.class.build_row
    end

    def rows
      @rows ||= begin
        rows = []

        _fields.each_value do |field|
          row.add_column_value(key: field.name, value: field.process(model))
        end

        _has_one.each_value do |has_one|
          simple_row = row.nested_rows[has_one.name]

          has_one.process_rows(model, simple_row)
        end

        rows.push(row)

        _has_many.each_value do |has_many|
          simple_row = row.nested_rows[has_many.name]

          resik = has_many.process_rows(model, simple_row)

          resik.map.with_index do |resik_row, index|
            if index.zero?
              # rows.push(new_row)
            else
              new_row = self.class.build_row

              copy_primary_fields(row, new_row)
              # TODO: copy ID here
              # copy_primary_attributes(new_row, row)
              new_row.nested_rows[has_many.name] = resik_row

              rows.push(new_row)
            end
          end
        end

        rows
      end
    end

    def headings
      row.headings
    end

    def copy_primary_fields(old_row, new_row)
      old_row.columns.each do |column|
        if column.is_primary
          new_row.add_column_value(key: column.key, value: column.value)
        end
      end
    end

    class << self
      # Default i18n scope for locales
      #
      # en:
      #   magic_report:
      #
      def i18n_scope
        :magic_report
      end

      def i18n_key
        name.underscore.tr("/", ".").to_sym
      end

      def field(*args)
        options = args.extract_options!
        name, processor = args

        reflection = Builder::Field.build(self, name, processor, options)

        Reflection.add_field(self, name, reflection)
      end

      def fields(*names)
        names.each { |name| field(name) }
      end

      def has_one(name, **options, &extension)
        reflection = Builder::HasOne.build(self, name, options, &extension)

        Reflection.add_has_one(self, name, reflection)
      end

      def has_many(name, **options, &extension)
        reflection = Builder::HasMany.build(self, name, options, &extension)

        Reflection.add_has_many(self, name, reflection)
      end

      # Building empty row for current report
      # This row doesn't include outer reports
      def build_row(prefix = nil)
        row = ::MagicReport::Report::Row.new

        _fields.each_value do |field|
          row.register_column(field.name, I18n.t!("#{i18n_scope}.#{i18n_key}.#{field.name}".tr("/", ".")), field.is_primary, prefix)
        end

        _has_one.each_value do |has_one|
          row.add_nested_row(key: has_one.name, row: has_one.build_row)
        end

        _has_many.each_value do |has_many|
          row.add_nested_row(key: has_many.name, row: has_many.build_row)
        end

        row
      end
    end
  end
end
