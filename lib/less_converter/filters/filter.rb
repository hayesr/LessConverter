module Filters
  class Filter
    attr_accessor :data

    def initialize(data)
      @data = data.dup
    end

    # Default filter does nothing
    def call
      data
    end
  end
end
