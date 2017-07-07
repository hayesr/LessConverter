require 'spec_helper'

RSpec.describe LessConverter::Dependency do
  context 'when arguments are wrong' do
    it 'raises an argument error' do
      expect { LessConverter::Dependency.new(name: 'foo', destination: 'bar') }.to raise_error(ArgumentError)
    end
  end
end
