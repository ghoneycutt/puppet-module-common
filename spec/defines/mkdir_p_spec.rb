require 'spec_helper'

describe 'common::mkdir_p' do
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

        it {
          is_expected.to contain_exec('mkdir_p-/some/dir/structure').with(
            {
              'command' => 'mkdir -p /some/dir/structure',
              'unless'  => 'test -d /some/dir/structure',
            },
          )
        }
      end

      context 'is_expected.to fail with a path that is not absolute' do
        let(:title) { 'not/a/valid/absolute/path' }

        it do
          expect {
            is_expected.to contain_exec('mkdir_p-not/a/valid/absolute/path').with(
              {
                'command' => 'mkdir -p not/a/valid/absolute/path',
                'unless'  => 'test -d not/a/valid/absolute/path',
              },
            )
          }.to raise_error(Puppet::Error)
        end
      end
    end
  end
end
