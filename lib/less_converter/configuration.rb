require 'yaml'

module LessConverter
  class Configuration
    attr_reader :data, :source, :destination

    def initialize(source:, destination:, yml_override: nil)
      @source = Pathname.new(source).expand_path
      raise ArgumentError.new('Could not find path') unless @source.exist?

      @destination = Pathname.new(destination).expand_path

      determine_yml_path(yml_override)
      raise ArgumentError.new('Could not find less_conversion yaml file') unless @yml_path.exist?

      @data = YAML.load( File.read(@yml_path) ).freeze
    end

    def dependencies
      @data['dependencies']
    end

    def pipelines
      @data['pipelines']
    end

    def import_overrides
      @data['import_overrides']
    end

    def file_overrides
      @data.fetch('file_overrides', {})
    end

    private

    def determine_yml_path(yml_override = nil)
      if yml_override.nil?
        @yml_path = @source.join('less_conversion.yml')
      else
        @yml_path = Pathname.new(yml_override).expand_path
      end
    end
  end
end
