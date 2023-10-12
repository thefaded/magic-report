# frozen_string_literal: true

module MagicReport
  class GeneralReport
    attr_reader :models, :report_klass, :csv, :fill

    def initialize(input, report_klass, options = {})
      @models = input.is_a?(Enumerable) ? input : [input]
      @report_klass = report_klass
      @csv = ::MagicReport::Report::Csv.new(self)
      @fill = options[:fill] || false
    end

    def generate
      models.find_each.with_index do |model, index|
        report = report_klass.new(model, fill)

        csv.add_headings(report) if index.zero?
        report.rows.each { |row| csv.add_row(row) }
      end
    end

    def as_attachment
      @as_attachment ||= {
        mime_type: "text/csv",
        content: csv.io.read
      }
    end
  end
end
