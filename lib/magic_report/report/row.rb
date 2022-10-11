# frozen_string_literal: true

module MagicReport
  class Report
    class Row
      attr_accessor :data, :inner_rows, :nested_rows

      def initialize
        @data = {}
        @inner_rows = {}
        @nested_rows = {}
      end

      def add(field:, value:)
        data[field] = value
      end

      def add_inner_row(field:, row:)
        inner_rows[field] = row
      end

      def add_nested_row(field:, row:)
        nested_rows[field] ||= []
        nested_rows[field].push(row)
      end

      def values
        data.values
      end

      def complex?
        nested_rows.any?
      end

      def each_nested_row(&block)
        nested_rows.keys.flat_map do |key|
          nested_rows[key].map do |nested_row|
            block.call(nested_row)
          end
        end
      end

      def each_inner_row(&block)
        inner_rows.values.map do |inner_row|
          block.call(inner_row)
        end
      end

      def to_h
        @to_h ||= begin
          original_hash = inner_rows.any? ? data.merge(each_inner_row { |inner_row| inner_row.to_h }.reduce({}, :merge)) : data

          if complex?
            each_nested_row do |nested_row|
              original_hash.merge(nested_row.to_h)
            end
          else
            original_hash
          end
        end
      end
    end
  end
end
