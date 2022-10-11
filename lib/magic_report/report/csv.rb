# frozen_string_literal: true

require "csv"

module MagicReport
  class Report
    class Csv
      attr_reader :report, :file, :csv

      def initialize(report)
        @report = report
        @file = Tempfile.new
        @csv = ::CSV.new(@file, write_headers: true)
      end

      def generate
        write_headers

        report.result.each do |row|
          row.to_h.each { |nested_row| csv << nested_row.values }
        end
        # ensure
        # file.close
      end

      def unlink
        file.unlink
      end

      private

      def write_headers
        csv << report.headings
      end
    end
  end
end
