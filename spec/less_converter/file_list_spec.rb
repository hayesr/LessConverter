require 'spec_helper'

RSpec.describe LessConverter::FileList do
  let(:directory) { fixtures_path.join('foo') }

  subject { LessConverter::FileList.new(directory) }

  it 'finds less files under the target directory' do
    expect(subject.files).to include(directory.join('src/bar/bar.less'))
    expect(subject.files).to include(directory.join('src/baz/baz.less'))
  end

  it 'ignores paths certain paths' do
    expect(subject.files).not_to include(directory.join('node_modules/foo.less'))
  end
end
