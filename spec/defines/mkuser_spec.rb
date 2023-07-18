require 'spec_helper'

clientversion = `facter puppetversion`

describe 'common::mkuser' do
  let(:title) { 'alice' }
  let(:facts) do
    {
      osfamily:      'RedHat',
      puppetversion: clientversion,
    }
  end

  context 'user alice with default values' do
    let(:params) { { uid: 1000 } }

    it do
      is_expected.to contain_user('alice').with(
        {
          'uid' => '1000',
          'gid'        => '1000',
          'shell'      => '/bin/bash',
          'home'       => '/home/alice',
          'ensure'     => 'present',
          'groups'     => 'alice',
          'password'   => '!!',
          'managehome' => 'true',
          'comment'    => 'created via puppet',
        },
      )
    end

    it do
      is_expected.to contain_file('/home/alice').with(
        {
          'owner' => 'alice',
          'group'   => 'alice',
          'mode'    => '0700',
         'require' => 'Common::Mkdir_p[/home/alice]',
        },
      )
    end

    it do
      is_expected.to contain_file('/home/alice/.ssh').with(
        {
          'ensure' => 'directory',
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

  context 'user alice with custom values' do
    let(:params) do
      {
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
    end

    it do
      is_expected.to contain_user('alice').with(
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
          'owner' => 'alice',
          'group'   => 'superusers',
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
          'owner'   => 'alice',
          'group'   => 'alice',
          'require' => 'User[alice]',
        },
      )
    end

    it { is_expected.to contain_common__mkdir_p('/home/superu') }

    it { is_expected.not_to contain_ssh_authorized_key('myuser') }
  end

  context 'do not manage home' do
    let(:params) do
      {
        'uid'        => 1000,
        'managehome' => false
      }
    end

    it { is_expected.not_to contain_file('/home/alice') }

    it { is_expected.not_to contain_common__mkdir_p('/home/alice') }

    it { is_expected.to contain_user('alice').with_managehome(false) }
  end

  context 'do not manage dotssh' do
    let(:params) do
      {
        'uid'           => 1000,
        'manage_dotssh' => false
      }
    end

    it { is_expected.not_to contain_file('/home/alice/.ssh') }

    it { is_expected.not_to contain_ssh_authorized_key('alice') }
  end

  describe 'with ssh_auth_key parameter specified' do
    context 'with defaults for ssh_auth_key_type parameter' do
      let(:params) do
        {
          'uid'          => 1000,
          'ssh_auth_key' => 'AAAB3NzaC1yc2EAAAABIwAAAQEArGElx46pD6NNnlxVaTbp0ZJMgBKCmbTCT3RaeCk0ZUJtQ8wkcwTtqIXmmiuFsynUT0DFSd8UIodnBOPqitimmooAVAiAi30TtJVzADfPScMiUnBJKZajIBkEMkwUcqsfh63' \
            '0jyBvLPE/kyQcxbEeGtbu1DG3monkeymanOBW1AKc5o+cJLXcInLnbowMG7NXzujT3BRYn/9s5vtT1V9cuZJs4XLRXQ50NluxJI7sVfRPVvQI9EMbTS4AFBXUej3yfgaLSV+nPZC/lmJ2gR4t/tKvMFF9m16f8' \
            'IcZKK7o0rK7v81G/tREbOT5YhcKLK+0wBfR6RsmHzwy4EddZloyLQ==',
        }
      end

      it do
        is_expected.to contain_ssh_authorized_key('alice').with(
          {
            'ensure'  => 'present',
            'user'    => 'alice',
            'key'     => 'AAAB3NzaC1yc2EAAAABIwAAAQEArGElx46pD6NNnlxVaTbp0ZJMgBKCmbTCT3RaeCk0ZUJtQ8wkcwTtqIXmmiuFsynUT0DFSd8UIodnBOPqitimmooAVAiAi30TtJVzADfPScMiUnBJKZajIBkEMkwUcqsfh630jyBv' \
              'LPE/kyQcxbEeGtbu1DG3monkeymanOBW1AKc5o+cJLXcInLnbowMG7NXzujT3BRYn/9s5vtT1V9cuZJs4XLRXQ50NluxJI7sVfRPVvQI9EMbTS4AFBXUej3yfgaLSV+nPZC/lmJ2gR4t/tKvMFF9m16f8IcZKK7o0rK7v81G/tREbO' \
              'T5YhcKLK+0wBfR6RsmHzwy4EddZloyLQ==',
            'type'    => 'ssh-dss',
            'require' => 'File[/home/alice/.ssh]',
          },
        )
      end
    end

    context 'with ssh_auth_key_type parameter specified' do
      let(:params) do
        {
          'uid'               => 1000,
          'ssh_auth_key'      => 'AAAB3NzaC1yc2EAAAABIwAAAQEArGElx46pD6NNnlxVaTbp0ZJMgBKCmbTCT3RaeCk0ZUJtQ8wkcwTtqIXmmiuFsynUT0DFSd8UIodnBOPqitimmooAVAiAi30TtJVzADfPScMiUnBJKZajIBkEMkwUcq' \
            'sfh630jyBvLPE/kyQcxbEeGtbu1DG3monkeymanOBW1AKc5o+cJLXcInLnbowMG7NXzujT3BRYn/9s5vtT1V9cuZJs4XLRXQ50NluxJI7sVfRPVvQI9EMbTS4AFBXUej3yfgaLSV+nPZC/lmJ2gR4t/tKvMFF9m16f8IcZKK7o0rK7' \
            'v81G/tREbOT5YhcKLK+0wBfR6RsmHzwy4EddZloyLQ==',
          'ssh_auth_key_type' => 'ssh-rsa',
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

  # purge_ssh_keys was introduced with Puppet 3.6.0
  # we need to know which version of Puppet is running this test
  # to decide which results we need to expect
  # dirty trick to get the running version of Puppet:
  clientversion = `facter puppetversion`
  # test environments contains no facts, we need to set it as fact

  describe "with purge_ssh_keys running on Puppet version #{clientversion}" do
    let(:facts) do
      {
        osfamily: 'RedHat',
        puppetversion: clientversion,
      }
    end

    context 'set to undef/nil' do
      let(:params) { { uid: 1000 } }

      if clientversion.to_f >= 3.6
        it { is_expected.to contain_user('alice').with_purge_ssh_keys(false) }
      else
        it { is_expected.to contain_user('alice').without_purge_ssh_keys }
      end
    end

    context 'set to true' do
      let(:params) do
        {
          'uid'            => 1000,
          'purge_ssh_keys' => true,
        }
      end

      if clientversion.to_f >= 3.6
        it { is_expected.to contain_user('alice').with_purge_ssh_keys(true) }
      else
        it { is_expected.to contain_user('alice').without_purge_ssh_keys }
      end
    end

    context 'set to false' do
      let(:params) do
        {
          'uid'            => 1000,
          'purge_ssh_keys' => false,
        }
      end

      if clientversion.to_f >= 3.6
        it { is_expected.to contain_user('alice').with_purge_ssh_keys(false) }
      else
        it { is_expected.to contain_user('alice').without_purge_ssh_keys }
      end
    end
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        osfamily: 'RedHat',
        puppetversion: clientversion,
      }
    end
    let(:validation_params) do
      {
        uid: 1000,
      }
    end

    validations = {
      'Boolean' => {
        name:    ['managehome', 'manage_dotssh'],
        valid:   [true, false],
        invalid: ['invalid', ['array'], { 'ha' => 'sh' }, 3, 2.42, nil],
        message: 'expects a Boolean',
      },
      'Optional[Boolean]' => {
        name:    ['purge_ssh_keys'],
        valid:   [true, false],
        invalid: ['invalid', ['array'], { 'ha' => 'sh' }, 3, 2.42, nil],
        message: 'expects a value of type Undef or Boolean',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:valid].each do |valid|
          context "with #{var_name} (#{type}) set to valid #{valid} (as #{valid.class})" do
            let(:params) { validation_params.merge({ "#{var_name}": valid, }) }

            it { is_expected.to compile }
          end
        end

        var[:invalid].each do |invalid|
          context "with #{var_name} (#{type}) set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { validation_params.merge({ "#{var_name}": invalid, }) }

            it 'fails' do
              expect {
                is_expected.to contain_class(:subject)
              }.to raise_error(Puppet::Error, %r{#{var[:message]}})
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
