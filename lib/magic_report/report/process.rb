# frozen_string_literal: true

module MagicReport
  class Report
    class Process
      attr_reader :report

      def initialize(report)
        @report = report
      end

      def call(input)
        if input.is_a? Enumerable
          input.map do |entity|
            process_entity(entity)
          end
        else
          process_entity(input)
        end
      end

      private

      def process_entity(entity)
        row = Row.new

        process_fields(entity, row)
        process_has_one(entity, row)
        process_has_many(entity, row)

        row
      end

      def process_fields(entity, row)
        report.fields.each do |field|
          row.add(field: report.resolve_path(field.key), value: field.process(entity))
        end
      end

      def process_has_one(entity, row)
        report.has_one.each do |association|
          inner_row = association.process_entity(entity.send(association.key))

          row.add_inner_row(field: report.resolve_path(association.key), row: inner_row)
        end
      end

      def process_has_many(entity, row)
        report.has_many.each do |association|
          entity.send(association.key).each do |entity|
            nested_row = association.process_entity(entity)

            row.add_nested_row(field: report.resolve_path(association.key), row: nested_row)
          end
        end
      end
    end
  end
end
