require "active_support/inflector/methods"

module LessConverter
  class Convertable
    attr_reader :path
    attr_accessor :pipeline

    def initialize(path, configuration:)
      @path = Pathname.new(path)
      @config = configuration

      @overrides = @config.file_overrides[rel_path.to_s]

      @pipeline = determine_pipeline
    end

    def rel_path
      path.relative_path_from(@config.source)
    end

    # run through pipeline of filters
    #
    def convert
      filter_classes.inject(data) do |subject, filter|
        filter.new(subject, configuration: @config).call
      end
    end

    def data
      @data ||= File.read(path)
    end

    def destination
      @destination ||= determine_destination
    end

    private

    def filter_classes
      pipeline.map { |f| safe_constantize("LessConverter::Filters::#{camelize(f)}") }.compact
    end

    def camelize(word)
      ActiveSupport::Inflector.camelize(word)
    end

    def safe_constantize(camel_cased_word)
      ActiveSupport::Inflector.safe_constantize(camel_cased_word)
    end

    def determine_destination
      if @overrides&.has_key?('destination')
        @config.destination.join(@overrides['destination'])
      else
        @config.destination.join(rel_path.to_s.gsub('.less', '.scss'))
      end
    end

    # First filters specified in a file overrride are used
    # Next a specified pipeline is used
    # Finally the default pipeline is returned
    #
    def determine_pipeline
      if @overrides&.has_key?('filters')
        @overrides['filters']
      elsif @overrides&.has_key?('pipeline')
        @config.pipelines[@overrides['pipeline']]
      else
        @config.pipelines['default']
      end
    end
  end
end
