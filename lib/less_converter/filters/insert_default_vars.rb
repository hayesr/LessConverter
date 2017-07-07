module LessConverter
  module Filters
    class InsertDefaultVars < Filter
      def call
        data.gsub(/^(\$.+);/, '\1 !default;')
      end
    end
  end
end
