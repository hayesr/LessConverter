require 'spec_helper'

RSpec.describe LessConverter::Configuration do
  let(:path) { fixtures_path.join('foo/less_conversion.yml') }

  subject(:instance) { LessConverter::Configuration.new(path) }

  it 'loads data' do
    expect(subject.data).to be_an_instance_of Hash
  end
end
