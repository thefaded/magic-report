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
      end

      # Don't forget to unlink in production code
      def unlink
        file.close
        file.unlink
      end

      def io
        io = csv.to_io
        io.rewind
        io
      end

      private

      def write_headers
        csv << report.headings
      end
    end
  end
end
