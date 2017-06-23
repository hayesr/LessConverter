require 'yaml'

module LessConverter
  class Configuration
    attr_reader :data

    def initialize(yml_path)
      @data = YAML.load File.read(yml_path)
    end
  end
end
