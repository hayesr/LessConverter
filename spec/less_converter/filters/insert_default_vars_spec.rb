require 'spec_helper'

RSpec.describe LessConverter::Filters::InsertDefaultVars do
  let(:less) { "$less-var;" }

  subject(:instance) { LessConverter::Filters::InsertDefaultVars.new(less) }

  it 'appends !default to the end of the line' do
    expect(subject.call).to eq "$less-var !default;"
  end
end
