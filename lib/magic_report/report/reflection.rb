# frozen_string_literal: true

module MagicReport
  class Report
    module Reflection
      extend ActiveSupport::Concern

      included do
        class_attribute :_fields, instance_writer: false, default: {}
        class_attribute :_has_one, instance_writer: false, default: {}
        class_attribute :_has_many, instance_writer: false, default: {}
      end

      class << self
        def add_field(klass, name, reflection)
          klass._fields = klass._fields.except(name).merge!(name => reflection)
        end

        def add_has_one(klass, name, reflection)
          klass._has_one = klass._has_one.except(name).merge!(name => reflection)
        end

        def add_has_many(klass, name, reflection)
          klass._has_many = klass._has_many.except(name).merge!(name => reflection)
        end
      end
    end
  end
end
