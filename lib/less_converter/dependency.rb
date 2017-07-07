module LessConverter
  class Dependency
    attr_reader :name, :destination, :path, :git

    def initialize(name:, destination:, path: nil, git: nil)
      raise ArgumentError.new("Must provide a path or git url") if path.nil? && git.nil?

      @name = name
      @path = path
      @git  = git
      @destination = destination
    end

    def fetch
      if path.nil?
        fetch_git
      else
        fetch_path
      end
    end

    def fetch_git
      system("git clone --depth 1 #{git} #{destination}")
    end

    def fetch_path
      system("cp -a #{path} #{destination}")
    end
  end
end
