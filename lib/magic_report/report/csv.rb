# frozen_string_literal: true

require "csv"

module MagicReport
  class Report
    class Csv
      attr_reader :report, :file, :csv

      def initialize(report)
        @file = Tempfile.new
        @csv = ::CSV.new(@file, write_headers: true)
      end

      def generate
        write_headers

        report.rows.each do |row|
          csv << row.to_a
        end
      end

      def add_headings(report)
        csv << report.headings
      end

      def add_row(row)
        csv << row.to_a
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
    end
  end
end
