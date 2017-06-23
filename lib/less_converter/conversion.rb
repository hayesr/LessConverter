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
    def self.from_url(source_url, destination, options = {})
      # download source to /tmp
      # source = "/tmp/tempsource"
      new(source, destination, options)
    end

    def initialize(source, destination, options = {})
      # do stuff
    end

    # create a new git commit or tag
    def git_commit
      # change to dir
      # git commit -am "msg"
    end
  end
end
