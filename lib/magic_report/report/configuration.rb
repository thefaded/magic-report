# frozen_string_literal: true

module MagicReport
  class Report
    module Configuration
      class Field
        attr_reader :key, :processor

        def initialize(key:, processor: nil)
          @key = key
          @processor = processor
        end

        def process(entity)
          processor ? processor.call(entity) : entity.send(key)
        end
      end

      class HasOne
        attr_reader :klass, :opts, :prefix, :key

        def initialize(klass:, opts:, key:)
          @klass = klass
          @prefix = opts[:prefix]
          @key = key
          @opts = opts
        end

        def process_entity(entity)
          report.process(entity)
        end

        def report
          @report ||= init_report
        end

        private

        # { class: Exports::Supplier, prefix: lambda }

        def init_report
          klass.new(report_params)
        end

        def report_opts
          opts
        end

        def report_params
          opts.reject { |k, v| %i[class].include? k }.merge(nested_field: key)
        end
      end

      class HasMany < HasOne; end
    end
  end
end
