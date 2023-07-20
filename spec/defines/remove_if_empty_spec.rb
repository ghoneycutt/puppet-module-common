require 'spec_helper'

describe 'common::remove_if_empty' do
  describe 'on supported OS RedHat' do
    # The following tests are OS independent, so we only test one supported OS
    redhat = {
      supported_os: [
        {
          'operatingsystem'        => 'RedHat',
          'operatingsystemrelease' => ['8'],
        },
      ],
    }

    on_supported_os(redhat).each do |_os, facts|
      let(:facts) { facts }

      context 'is_expected.to create new directory' do
        let(:title) { '/some/dir/structure' }

        it do
          is_expected.to contain_exec('remove_if_empty-/some/dir/structure').with(
            {
              'command' => 'rm -f /some/dir/structure',
              'unless'  => 'test -f /some/dir/structure; if [ $? == \'0\' ]; then test -s /some/dir/structure; fi',
              'path'    => '/bin:/usr/bin:/sbin:/usr/sbin',
            },
          )
        end
      end

      context 'is_expected.to fail with a path that is not absolute' do
        let(:title) { 'not/a/valid/absolute/path' }

        it do
          expect {
            is_expected.to contain_exec('remove_if_empty-not/a/valid/absolute/path')
          }.to raise_error(Puppet::Error)
        end
      end
    end
  end
end
