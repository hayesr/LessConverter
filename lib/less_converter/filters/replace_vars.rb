module Filters
  # Changes Less vars into Sass vars
  # Skips syntax that should begin with @
  #
  class ReplaceVars < Filter
    def call
      data.gsub(/(?!#{skip_words}|@-\w)@/, '$')
    end

    private

    def skip_words
      %w(
        mixin
        media
        page
        supports
        keyframes
        font-face
      ).map { |e| "@#{e}" }.join('|')
    end
  end
end
