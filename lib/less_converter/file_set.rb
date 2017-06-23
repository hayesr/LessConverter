module LessConverter
  class FileSet
    attr_reader :files
    # finds all files with extension under path
    def initialize(path, ext = "less")
      # find all files with extension under path
      @files = find_files(path, ext)
    end

    private

    def find_files(path, ext)
      Dir["#{path}/**/*.#{ext}"].map { |p| p.gsub(path.to_s, '') }
    end
  end
end
