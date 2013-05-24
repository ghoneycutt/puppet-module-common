require 'spec_helper'

describe 'common::mkdir_p' do
  context 'should create new directory' do
    let(:title) { '/some/dir/structure' }

    it {
      should contain_exec('mkdir_p-/some/dir/structure').with({
        'command' => 'mkdir -p /some/dir/structure',
        'unless'  => 'test -d /some/dir/structure',
      })
    }
  end
end
