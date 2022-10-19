# frozen_string_literal: true

module MagicReport
  class Report
    class Row
      class Column
        attr_reader :key, :heading, :is_primary, :prefix, :value

        def initialize(key, heading, is_primary, prefix)
          @key = key
          @heading = heading
          @is_primary = is_primary
          @prefix = prefix
          @value = nil
        end

        def assign_value(value)
          @value = value
        end

        def full_heading
          prefix.present? ? "#{prefix} #{heading}" : heading
        end
      end

      attr_reader :columns, :nested_rows

      def initialize
        @columns = []
        @nested_rows = {}
      end

      def add_column_value(key:, value:)
        @columns.find { |column| column.key == key }.assign_value(value)
      end

      def add_nested_row(key:, row:)
        nested_rows[key] = row
      end

      def register_column(key, heading, is_primary, prefix = nil)
        @columns << Column.new(key, heading, is_primary, prefix)
      end

      def headings
        (columns.map(&:full_heading) + nested_rows.values.map(&:headings)).flatten
      end

      def to_a
        (columns.map(&:value) + nested_rows.values.map(&:to_a)).flatten
      end
    end
  end
end
