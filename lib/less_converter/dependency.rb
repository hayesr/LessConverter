module LessConverter
  class Dependency
    def initialize(name:, destination:, path: nil, git: nil)
      raise ArgumentError.new("Must provide a path or git url") if path.nil? && git.nil?
    end
  end
end
