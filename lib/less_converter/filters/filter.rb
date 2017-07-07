module LessConverter
  module Filters
    class Filter
      attr_accessor :data, :config

      def initialize(data, configuration: {})
        @data   = data.dup
        @config = configuration
      end

      # Default filter does nothing
      def call
        data
      end
    end
  end
end
