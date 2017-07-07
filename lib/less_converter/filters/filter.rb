module LessConverter
  module Filters
    class Filter
      attr_accessor :data, :config

      def initialize(data, config: {})
        @data   = data.dup
        @config = config
      end

      # Default filter does nothing
      def call
        data
      end
    end
  end
end
