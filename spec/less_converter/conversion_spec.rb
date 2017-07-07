require 'spec_helper'

# work out dependencies
# -- specified dependencies should be converted first (patternfly)
# -- -- run interactively to ask about modules?
# -- -- if the dependency has a less_conversion.yml then convert (recursively?)
# -- yarn should be run to fetch node modules
# find files in directories
# find imports

RSpec.describe LessConverter::Conversion do
  let(:source)      { fixtures_path.join('foo') }
  let(:destination) { temp_path.join('foo-sass') }

  subject(:instance) { LessConverter::Conversion.new(source, destination) }

  describe 'setup' do
    it 'finds dependencies' do
      expect(subject.dependencies).not_to be_empty
      expect(subject.dependencies.first).to be_an_instance_of LessConverter::Dependency
    end
  end

  describe 'converting' do
    context 'when the destination directory does not exist' do
      before do
        destination.rmtree if destination.exist?
      end

      it 'creates the directory' do
        expect { subject.convert }.not_to raise_error
        expect(destination).to exist
      end
    end
  end
end
