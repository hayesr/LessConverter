require 'spec_helper'

RSpec.describe LessConverter::Filters::ReplaceVars do
  subject(:instance) { LessConverter::Filters::ReplaceVars }

  it 'replaces variables' do
    expect(subject.new("@less-var").call).to eq "$less-var"
  end

  it 'does not modify @mixin syntax' do
    expect(subject.new("@mixin").call).to eq "@mixin"
  end

  it 'does not modify @media' do
    expect(subject.new("@media").call).to eq "@media"
  end

  it 'does not modify @page' do
    expect(subject.new("@page").call).to eq "@page"
  end

  it 'does not modify @supports' do
    expect(subject.new("@supports").call).to eq "@supports"
  end
end
