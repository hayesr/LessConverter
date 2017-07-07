require 'spec_helper'

RSpec.describe LessConverter::Convertable do
  let(:source_dir) { fixtures_path.join('foo') }
  let(:dest_dir)   { temp_path.join('foo-sass') }
  let(:file_path)  { source_dir.join('src', 'bar', 'bar.less') }

  let(:config) do
    LessConverter::Configuration.new(source: source_dir, destination: dest_dir)
  end

  subject { LessConverter::Convertable.new(file_path, configuration: config) }

  it 'has a list of filters' do
    expect(subject.pipeline).to include('replace_vars')
    expect(subject.pipeline).to include('replace_file_imports')
  end

  it 'has a simple path' do
    expect(subject.rel_path).to eq Pathname.new('src/bar/bar.less')
  end

  it 'converts the data' do
    expect(subject.convert).to eq "$bar-var: #dead00;\n"
  end

  describe 'destination path' do
    subject { LessConverter::Convertable.new(file_path, configuration: config).destination }

    context 'when destination is from commandline' do
      let(:cli_based_path) { dest_dir.join('src', 'bar', 'bar.scss') }

      let(:config) do
        LessConverter::Configuration.new(
          source: source_dir,
          destination: dest_dir,
          yml_override: source_dir.join('min_config.yml')
        )
      end

      it { is_expected.to eq cli_based_path }
    end

    context 'when destination is overriden by file_overrides' do
      let(:dest) { dest_dir.join('overriden', 'overriden_file.scss') }

      it { is_expected.to eq dest }
    end
  end

  describe 'conversion' do
    it 'is not nil' do
      expect(subject.convert).not_to be_nil
    end
  end
end
