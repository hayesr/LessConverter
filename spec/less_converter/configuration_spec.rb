require 'spec_helper'

RSpec.describe LessConverter::Configuration do
  let(:source)      { fixtures_path.join('foo') }
  let(:destination) { temp_path.join('foo-sass') }

  subject { LessConverter::Configuration.new(source: source, destination: destination) }

  it 'finds the yaml config file' do
    expect{ subject }.not_to raise_error
  end

  it 'loads data' do
    expect(subject.data).to be_an_instance_of Hash
  end

  it 'accesses pipelines' do
    expected = { 'imports_only' => ['replace_file_imports'] }
    expect(subject.pipelines).to include(expected)
  end

  context 'when missing source is given' do
    subject do
      LessConverter::Configuration.new(
        source: temp_path.join('bad/path'),
        destination: destination,
        yml_override: fixtures_path.join('foo/empty_config.yml')
      )
    end

    it 'raises an error' do
      expect { subject }.to raise_error(ArgumentError)
    end
  end
end
