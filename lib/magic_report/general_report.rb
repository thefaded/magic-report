# frozen_string_literal: true

module MagicReport
  class GeneralReport
    attr_reader :models, :report_klass, :csv

    def initialize(input, report_klass)
      @models = input.is_a?(Enumerable) ? input : [input]
      @report_klass = report_klass
      @csv = ::MagicReport::Report::Csv.new(self)
    end

    def as_attachment
      @as_attachment ||= begin
        generate

        {
          mime_type: "text/csv",
          content: csv.io.read
        }
      end
    end

    private

    def generate
      models.each.with_index do |model, index|
        report = report_klass.new(model)

        csv.add_headings(report) if index.zero?
        report.rows.each { |row| csv.add_row(row) }
      end
    end
  end
end
