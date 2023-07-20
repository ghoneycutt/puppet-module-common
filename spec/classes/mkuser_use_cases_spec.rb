require 'spec_helper'

clientversion = `facter puppetversion`

describe 'common' do
  describe 'use cases on supported OS RedHat' do
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
      let(:facts) do
        facts.merge(
          {
            puppetversion: clientversion,
          },
        )
      end

      context 'one user with default values' do
        let(:params) do
          {
            users: {
              'alice' => {
                'uid' => 1000,
              }
            }
          }
        end

        it do
          is_expected.to contain_user('alice').with(
            {
              'uid'        => '1000',
              'gid'        => '1000',
              'shell'      => '/bin/bash',
              'home'       => '/home/alice',
              'ensure'     => 'present',
              'groups'     => 'alice',
              'password'   => '!!',
              'managehome' => true,
              'comment'    => 'created via puppet',
            },
          )
        end

        it do
          is_expected.to contain_file('/home/alice').with(
            {
              'owner'   => 'alice',
              'mode'    => '0700',
              'require' => 'Common::Mkdir_p[/home/alice]',
            },
          )
        end

        it do
          is_expected.to contain_file('/home/alice/.ssh').with(
            {
              'ensure'  => 'directory',
              'mode'    => '0700',
              'owner'   => 'alice',
              'group'   => 'alice',
              'require' => 'User[alice]',
            },
          )
        end

        it { is_expected.to contain_common__mkdir_p('/home/alice') }

        it do
          is_expected.to contain_group('alice').with(
            {
              'ensure' => 'present',
              'gid'    => 1000,
              'name'   => 'alice',
            },
          )
        end

        it { is_expected.not_to contain_ssh_authorized_key('alice') }
      end

      context 'one user with custom values' do
        let(:params) do
          {
            users: {
              'myuser' => {
                'uid'      => 2000,
                'group'    => 'superusers',
                'gid'      => 2000,
                'shell'    => '/bin/zsh',
                'home'     => '/home/superu',
                'groups'   => ['superusers', 'development', 'admins'],
                'password' => 'puppet',
                'mode'     => '0701',
                'comment'  => 'a puppet master',
              }
            }
          }
        end

        it do
          is_expected.to contain_user('myuser').with(
            {
              'uid' => '2000',
              'gid'      => '2000',
              'shell'    => '/bin/zsh',
              'home'     => '/home/superu',
              'groups'   => ['superusers', 'development', 'admins'],
              'password' => 'puppet',
              'comment'  => 'a puppet master',
            },
          )
        end

        it do
          is_expected.to contain_file('/home/superu').with(
            {
              'owner' => 'myuser',
              'mode'    => '0701',
              'require' => 'Common::Mkdir_p[/home/superu]',
            },
          )
        end

        it do
          is_expected.to contain_file('/home/superu/.ssh').with(
            {
              'ensure' => 'directory',
              'mode'    => '0700',
              'owner'   => 'myuser',
              'group'   => 'myuser',
              'require' => 'User[myuser]',
            },
          )
        end

        it { is_expected.to contain_common__mkdir_p('/home/superu') }
        it { is_expected.to contain_exec('mkdir_p-/home/superu') } # only needed to reach 100% resource coverage
        it { is_expected.to contain_common__mkuser('myuser') }     # only needed to reach 100% resource coverage
        it { is_expected.to contain_group('myuser') }              # only needed to reach 100% resource coverage

        it { is_expected.not_to contain_ssh_authorized_key('myuser') }
      end

      context 'two users with default values' do
        let(:params) do
          {
            users: {
              'alice' => {
                'uid' => 1000,
              },
               'bob' => {
                 'uid' => 1001,
               }
            }
          }
        end

        it do
          is_expected.to contain_user('alice').with(
            {
              'uid'        => 1000,
              'gid'        => 1000,
              'shell'      => '/bin/bash',
              'home'       => '/home/alice',
              'ensure'     => 'present',
              'managehome' => true,
              'groups'     => 'alice',
              'password'   => '!!',
              'comment'    => 'created via puppet',
            },
          )
        end

        it do
          is_expected.to contain_user('bob').with(
            {
              'uid'        => 1001,
              'gid'        => 1001,
              'shell'      => '/bin/bash',
              'home'       => '/home/bob',
              'ensure'     => 'present',
              'managehome' => true,
              'groups'     => 'bob',
              'password'   => '!!',
              'comment'    => 'created via puppet',
            },
          )
        end

        it { is_expected.to contain_common__mkdir_p('/home/alice') }
        it { is_expected.to contain_common__mkdir_p('/home/bob') }

        it { is_expected.to contain_exec('mkdir_p-/home/alice') } # only needed to reach 100% resource coverage
        it { is_expected.to contain_exec('mkdir_p-/home/bob') }   # only needed to reach 100% resource coverage
        it { is_expected.to contain_common__mkuser('alice') }     # only needed to reach 100% resource coverage
        it { is_expected.to contain_common__mkuser('bob') }       # only needed to reach 100% resource coverage
        it do
          is_expected.to contain_file('/home/alice').with(
            {
              'owner'   => 'alice',
              'mode'    => '0700',
              'require' => 'Common::Mkdir_p[/home/alice]',
            },
          )
        end

        it do
          is_expected.to contain_file('/home/bob').with(
            {
              'owner' => 'bob',
              'mode'    => '0700',
              'require' => 'Common::Mkdir_p[/home/bob]',
            },
          )
        end

        it do
          is_expected.to contain_file('/home/alice/.ssh').with(
            {
              'ensure'  => 'directory',
              'mode'    => '0700',
              'owner'   => 'alice',
              'group'   => 'alice',
              'require' => 'User[alice]',
            },
          )
        end

        it do
          is_expected.to contain_file('/home/bob/.ssh').with(
            {
              'ensure' => 'directory',
              'mode'    => '0700',
              'owner'   => 'bob',
              'group'   => 'bob',
              'require' => 'User[bob]',
            },
          )
        end

        it do
          is_expected.to contain_group('alice').with(
            {
              'ensure' => 'present',
              'gid'    => 1000,
              'name'   => 'alice',
            },
          )
        end

        it do
          is_expected.to contain_group('bob').with(
            {
              'ensure' => 'present',
              'gid'    => 1001,
              'name'   => 'bob',
            },
          )
        end

        ['alice', 'bob'].each do |name|
          it { is_expected.not_to contain_ssh_authorized_key(name) }
        end
      end

      context 'do not manage home' do
        let(:params) do
          {
            users: {
              'alice' => {
                'uid'        => 1000,
                'managehome' => false
              }
            }
          }
        end

        it { is_expected.not_to contain_file('/home/alice') }

        it { is_expected.not_to contain_common__mkdir_p('/home/alice') }

        it { is_expected.to contain_user('alice').with_managehome(false) }
      end

      context 'do not manage dotssh' do
        let(:params) do
          {
            users: {
              'alice' => {
                'uid'           => 1000,
                'manage_dotssh' => false
              }
            }
          }
        end

        it { is_expected.not_to contain_file('/home/alice/.ssh') }

        it { is_expected.not_to contain_ssh_authorized_key('alice') }
      end

      describe 'with ssh_auth_key parameter specified' do
        context 'with defaults for ssh_auth_key_type parameter' do
          let(:params) do
            {
              users: {
                'alice' => {
                  'uid'          => 1000,
                  'ssh_auth_key' => 'AAAB3NzaC1yc2EAAAABIwAAAQEArGElx46pD6NNnlxVaTbp0ZJMgBKCmbTCT3RaeCk0ZUJtQ8wkcwTtqIXmmiuFsynUT0DFSd8UIodnBOPqitimmooAVAiAi30TtJVzADfPScMiUnBJKZajIBkEMkwUcqs' \
                    'fh630jyBvLPE/kyQcxbEeGtbu1DG3monkeymanOBW1AKc5o+cJLXcInLnbowMG7NXzujT3BRYn/9s5vtT1V9cuZJs4XLRXQ50NluxJI7sVfRPVvQI9EMbTS4AFBXUej3yfgaLSV+nPZC/lmJ2gR4t/tKvMFF9m16f8IcZKK7o0' \
                    'rK7v81G/tREbOT5YhcKLK+0wBfR6RsmHzwy4EddZloyLQ==',
                }
              }
            }
          end

          it do
            is_expected.to contain_ssh_authorized_key('alice').with(
              {
                'ensure'  => 'present',
                'user'    => 'alice',
                'key'     => 'AAAB3NzaC1yc2EAAAABIwAAAQEArGElx46pD6NNnlxVaTbp0ZJMgBKCmbTCT3RaeCk0ZUJtQ8wkcwTtqIXmmiuFsynUT0DFSd8UIodnBOPqitimmooAVAiAi30TtJVzADfPScMiUnBJKZajIBkEMkwUcqsfh630jy' \
                  'BvLPE/kyQcxbEeGtbu1DG3monkeymanOBW1AKc5o+cJLXcInLnbowMG7NXzujT3BRYn/9s5vtT1V9cuZJs4XLRXQ50NluxJI7sVfRPVvQI9EMbTS4AFBXUej3yfgaLSV+nPZC/lmJ2gR4t/tKvMFF9m16f8IcZKK7o0rK7v81G/t' \
                  'REbOT5YhcKLK+0wBfR6RsmHzwy4EddZloyLQ==',
                'type'    => 'ssh-dss',
                'require' => 'File[/home/alice/.ssh]',
              },
            )
          end
        end

        context 'with ssh_auth_key_type parameter specified' do
          let(:params) do
            {
              users: {
                'alice' => {
                  'uid'               => 1000,
                  'ssh_auth_key'      => 'AAAB3NzaC1yc2EAAAABIwAAAQEArGElx46pD6NNnlxVaTbp0ZJMgBKCmbTCT3RaeCk0ZUJtQ8wkcwTtqIXmmiuFsynUT0DFSd8UIodnBOPqitimmooAVAiAi30TtJVzADfPScMiUnBJKZajIBkEMk' \
                    'wUcqsfh630jyBvLPE/kyQcxbEeGtbu1DG3monkeymanOBW1AKc5o+cJLXcInLnbowMG7NXzujT3BRYn/9s5vtT1V9cuZJs4XLRXQ50NluxJI7sVfRPVvQI9EMbTS4AFBXUej3yfgaLSV+nPZC/lmJ2gR4t/tKvMFF9m16f8IcZ' \
                    'KK7o0rK7v81G/tREbOT5YhcKLK+0wBfR6RsmHzwy4EddZloyLQ==',
                  'ssh_auth_key_type' => 'ssh-rsa',
                }
              }
            }
          end

          it do
            is_expected.to contain_ssh_authorized_key('alice').with(
              {
                'ensure'  => 'present',
                'user'    => 'alice',
                'key'     => 'AAAB3NzaC1yc2EAAAABIwAAAQEArGElx46pD6NNnlxVaTbp0ZJMgBKCmbTCT3RaeCk0ZUJtQ8wkcwTtqIXmmiuFsynUT0DFSd8UIodnBOPqitimmooAVAiAi30TtJVzADfPScMiUnBJKZajIBkEMkwUcqsfh630jy' \
                  'BvLPE/kyQcxbEeGtbu1DG3monkeymanOBW1AKc5o+cJLXcInLnbowMG7NXzujT3BRYn/9s5vtT1V9cuZJs4XLRXQ50NluxJI7sVfRPVvQI9EMbTS4AFBXUej3yfgaLSV+nPZC/lmJ2gR4t/tKvMFF9m16f8IcZKK7o0rK7v81G/t' \
                  'REbOT5YhcKLK+0wBfR6RsmHzwy4EddZloyLQ==',
                'type'    => 'ssh-rsa',
                'require' => 'File[/home/alice/.ssh]',
              },
            )
          end
        end
      end
    end
  end
end
