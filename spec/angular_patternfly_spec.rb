require 'spec_helper'

RSpec.describe "Angular-patternfly conversion" do
  # work out dependencies
  # -- specified dependencies should be converted first (patternfly)
  # -- -- run interactively to ask about modules?
  # -- -- if the dependency has a less_conversion.yml then convert (recursively?)
  # -- yarn should be run to fetch node modules
  # find files in directories
  # find imports

  let(:aps_fixture_path) { fixtures_path.join('angular-patternfly-sass') }

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
    before do
      destination.rmtree
      subject.convert
    end

    it 'writes a scss file for every less file' do
      expect(subject.config.source).to eq source
      expect( Dir["#{destination}/**/*.scss"].count ).to eq subject.files.count
    end

    it 'should copy other files too' do
      expect( destination.join('src').find.count ).to eq source.join('src').find.count
    end
  end

  describe 'dealing with dependencies' do
    # The patternfly-sass project should be a dependency
    it 'finds the patternfly-sass dependency' do
      expect(subject.config.dependencies).to include('patternfly-sass')
    end

    # The color-variables file should be overriden with the sass version
    it 'overrides the color-variables import path' do
      expect(subject.config.import_overrides).to include('../node_modules/patternfly/dist/less/color-variables.less')

      entry = subject.convertables.detect { |c| c.path.to_s =~ /angular-patternfly\.less/ }

      expect(entry.pipeline).to include('replace_file_imports')

      # At time of writing, angular-patternfly.less ended in 2 empty lines
      expect(entry.convert.chomp).to eq aps_fixture_path.join('styles', 'angular-patternfly.scss').read
    end

    it 'downloads the dependency from git' do
      subject.fetch_dependencies
      expect(destination.join('vendor', 'patternfly-sass')).to exist
    end
  end
end
