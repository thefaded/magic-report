# frozen_string_literal: true

module MagicReport
  class Report
    class Builder
      class HasOne
        def self.build(report, name, options, &extension)
          new(report, name, options, extension)
        end

        attr_reader :report, :name, :options, :extension, :prefix

        def initialize(report, name, options, extension)
          @report = report
          @name = name
          @options = options
          @extension = extension
          @prefix = I18n.t!("#{report.i18n_scope}.#{report.i18n_key}.#{name}_relation")

          unless options[:class]
            klass = ::MagicReport::Report.clone
            klass.define_singleton_method(:name) { "#{report.name}/#{name}" }
            klass.class_eval(&extension)

            options[:class] = klass
          end
        end

        def process(model)
          relation = extract_relation(model)

          # Refactor here values method call
          options[:class].new(relation, is_fill).values
        end

        def process_rows(model, row, is_fill)
          relation = extract_relation(model)

          # Refactor here values method call
          options[:class].new(relation, is_fill, row).rows
        end

        def build_row
          options[:class].build_row(prefix)
        end

        private

        def extract_relation(model)
          model.send(name)
        end
      end
    end
  end
end
