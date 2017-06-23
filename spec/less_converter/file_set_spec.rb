require 'spec_helper'

RSpec.describe LessConverter::FileSet do
  let(:directory) { fixtures_path.join('foo') }

  subject { LessConverter::FileSet.new(directory) }

  it 'finds less files under the target directory' do
    expect(subject.files).to include('/src/bar/bar.less')
    expect(subject.files).to include('/src/baz/baz.less')
  end
end
