module LessConverter
  module Filters
    class ReplaceFileImports < Filter
      IMPORT_REGEX = /^@import\s+(?:\(\w+\)\s+)?["|']([\w\-\.\/]+)["|']\;/.freeze

      def call
        # patternfly-sass implementation: leave less extension

        # data.gsub!(
        #   %r{[@\$]import\s+(?:\(\w+\)\s+)?["|']([\w\-\./]+).less["|'];},
        #   "@import \"\\1\";"
        # )
        #
        # data.gsub!(
        #   %r{[@\$]import\s+(?:\(\w+\)\s+)?["|']([\w\-\./]+).(css)["|'];},
        #   "@import \"\\1.\\2\";"
        # )

        # data.gsub(/\.less/, '.scss')

        replace_imports
        data.gsub(/\.less/, '.scss')
      end

      private

      def imports
        @imports ||= begin
          data.lines.flat_map { |line| normalize_import(line) if line =~ IMPORT_REGEX }
        end
      end

      def replace_imports
        imports.each do |import|
          data.gsub!(import, overrides[import]) if overrides.has_key?(import)
        end
      end

      def overrides
        config['import_replacements'] || {}
      end

      def normalize_import(str)
        str.scan(IMPORT_REGEX).flatten
      end
    end
  end
end
