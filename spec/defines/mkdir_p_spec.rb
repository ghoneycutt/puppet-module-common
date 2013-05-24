require 'spec_helper'

describe 'common::mkdir_p' do
  context 'should create new directory' do
    let(:title) { '/nonexistent' }

    it do
      should contain_exec('mkdir_p-/nonexistent').with_command('mkdir -p /nonexistent')
    end
  end
end
