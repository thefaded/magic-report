# frozen_string_literal: true

module MagicReport
  class Report
    class Builder
      class HasMany < HasOne
        def process_rows(model, row, is_fill)
          extract_relation(model).flat_map.with_index do |rel, idx|
            # If we're on a first entry, then we should fill first row
            # Otherwise will be created a new row
            if idx.zero?
              options[:class].new(rel, is_fill, row).rows
            else
              options[:class].new(rel, is_fill).rows
            end
          end
        end
      end
    end
  end
end
