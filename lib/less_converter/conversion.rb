module LessConverter
  ##
  # Manages the conversion of a source project
  #
  class Conversion
    # Convert a remote source
    # pulls down the source to /tmp
    #
    # :args: source_url, destination, options
    #
    def self.from_url(source_url, destination)
      # download source to /tmp
      # source = "/tmp/tempsource"
      new(source, destination)
    end

    attr_reader :source, :destination, :config
    attr_writer :file_list

    def initialize(source, destination, config_file: nil)
      @source      = source
      @destination = destination
      @config      = load_config(source, destination, config_file)
    end

    def dependencies
      @dependencies ||= @config.dependencies.map do |name, options|
        Dependency.new(
          name: name,
          path: options['path'],
          git: options['git'],
          destination: @config.destination.join(options['destination'])
        )
      end
    end

    def files
      @file_list ||= FileList.new(@config.source).files
    end

    def convertables
      @convertables ||= files.map do |file|
        Convertable.new(file, configuration: config)
      end
    end

    def convert
      convertables.each do |convertable|
        prep_destination(convertable.destination.dirname)

        File.open(convertable.destination, 'w') do |f|
          f.write convertable.convert
        end
      end
    end

    def fetch_dependencies
      dependencies.each(&:fetch)
    end

    # TODO: create a new git commit or tag
    # def git_commit
    #   # change to dir
    #   # git commit -am "msg"
    # end

    private

    def load_config(source, destination, config_file = nil)
      yaml_path = config_file ? config_file : "#{source}/less_conversion.yml"

      Configuration.new(source: @source, destination: @destination, yml_override: yaml_path)
    end

    def prep_destination(path)
      path.mkpath unless path.exist?
    end
  end
end
