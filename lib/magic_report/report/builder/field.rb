# frozen_string_literal: true

module MagicReport
  class Report
    class Builder
      class Field
        def self.build(report, name, processor, options)
          new(report, name, processor, options)
        end

        attr_reader :report, :name, :processor, :is_primary

        def initialize(report, name, processor, options)
          @report = report
          @name = name
          @processor = processor
          @is_primary = options.fetch(:primary, false)
        end

        def process(model)
          value = extract_value(model)

          if processor.is_a? Proc
            processor.call(model, value)
          elsif processor.is_a? Symbol
            # Refactor
            report.new(nil).send(processor, model, value)
          else
            value
          end
        end

        private

        def extract_value(model)
          model.send(name)
        rescue
          nil
        end
      end
    end
  end
end
