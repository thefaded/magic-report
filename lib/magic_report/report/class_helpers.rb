# frozen_string_literal: true

module MagicReport
  class Report
    module ClassHelpers
      def name_from_class
        ::MagicReport::Utils.underscore(self.class.name).tr("/", ".")
      end

      def fields_from_class
        self.class.instance_variable_get(:@fields) || []
      end

      def has_one_from_class
        self.class.instance_variable_get(:@has_one) || []
      end

      def has_many_from_class
        self.class.instance_variable_get(:@has_many) || []
      end
    end
  end
end
