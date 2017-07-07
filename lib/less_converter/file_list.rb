require 'set'

module LessConverter
  class FileList
    attr_reader :source, :ext, :files
    # finds all files with extension under source directory
    def initialize(source, ext = "less")
      @source  = source
      @ext   = ext
      @files = find_files(source)
    end

    def relative_paths
      @rel_paths ||= files.map { |p| p.gsub("#{source}/", '') }
    end

    private

    def ignored_paths
      # relativize_paths(Dir["#{source.join('node_modules')}/**/*.#{ext}"])
      Dir["#{source.join('node_modules')}/**/*.#{ext}"].map do |path|
        Pathname.new(path).expand_path
      end
    end

    def find_files(source)
      # Set.new(relativize_paths(Dir["#{source}/**/*.#{ext}"]) - ignored_paths)
      # Set.new(Dir["#{source}/**/*.#{ext}"] - ignored_paths)
      Dir["#{source}/**/*.#{ext}"].map { |path| Pathname.new(path).expand_path } - ignored_paths
    end

    # def relativize_paths(paths)
    #   paths.map { |p| p.gsub("#{source}/", '') }
    # end
  end
end
