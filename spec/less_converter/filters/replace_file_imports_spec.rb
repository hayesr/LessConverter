require 'spec_helper'

RSpec.describe LessConverter::Filters::ReplaceFileImports do

  describe 'replacing less extension' do
    let(:less) { "@import 'my-less-file.less';" }

    subject { LessConverter::Filters::ReplaceFileImports.new(less).call }

    it { is_expected.to eq "@import 'my-less-file.scss';" }
  end

  describe 'overriding import statements' do
    let(:config) do
      {
        'import_replacements' => {
          'override-me.less' => 'path/to/override_file.scss'
        }
      }
    end

    let(:less) do
      File.read(fixtures_path.join('filters', 'replace_file_imports', 'example.less'))
    end

    let(:converted) do
      File.read(fixtures_path.join('filters', 'replace_file_imports', 'expected.scss'))
    end

    subject { LessConverter::Filters::ReplaceFileImports.new(less, config: config).call }

    it { is_expected.to eq converted }
  end
end
