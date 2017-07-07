require 'spec_helper'

RSpec.describe "Angular-patternfly conversion" do
  # work out dependencies
  # -- specified dependencies should be converted first (patternfly)
  # -- -- run interactively to ask about modules?
  # -- -- if the dependency has a less_conversion.yml then convert (recursively?)
  # -- yarn should be run to fetch node modules
  # find files in directories
  # find imports

  let(:source)      { Pathname.new('../angular-patternfly').expand_path(project_path) }
  let(:destination) { Pathname.new('tmp/angular-patternfly-sass').expand_path(project_path) }

  subject(:instance) do
    opts = {
      config_file: project_path.join('converters', 'angular-patternfly', 'less_conversion.yml')
    }

    LessConverter::Conversion.new(source, destination, **opts)
  end

  describe 'setup' do
    it 'loads the configuration' do
      expect(subject.config).to be_an_instance_of LessConverter::Configuration
    end

    it 'determines the source directory' do
      expect(subject.source).to eq project_path.join('..', 'angular-patternfly')
    end

    it 'determines the destination directory' do
      expect(subject.destination).to eq temp_path.join('angular-patternfly-sass')
    end

    it 'finds dependencies' do
      expect(subject.dependencies).not_to be_empty
    end
  end

  describe 'finding files' do
    it 'finds less files under component directories' do
      expect(subject.files).to include source.join('src/card/card.less')
    end
  end

  describe 'per file configuration' do
    # check that the file gets the right pipeline
    it 'wraps presents files as Convertables' do
      expect(subject.convertables.first).to be_an_instance_of LessConverter::Convertable
    end
  end

  describe 'writing files' do
    it 'writes a scss file for every less file' do
      subject.convert
      expect(subject.config.source).to eq source
      expect( Dir["#{destination}/**/*.scss"].count ).to eq subject.files.count
    end
  end
end
