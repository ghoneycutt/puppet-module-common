require 'spec_helper'

describe 'common::mkuser' do
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
      let(:title) { 'alice' }

      context 'user alice with default values' do
        let(:params) { { uid: 1000 } }

        it do
          is_expected.to contain_user('alice').only_with(
            {
              'ensure'         => 'present',
              'uid'            => '1000',
              'gid'            => '1000',
              'shell'          => '/bin/bash',
              'groups'         => 'alice',
              'password'       => '!!',
              'managehome'     => 'true',
              'home'           => '/home/alice',
              'comment'        => 'created via puppet',
              'purge_ssh_keys' => false
            },
          )
        end

        it do
          is_expected.to contain_group('alice').only_with(
            {
              'ensure' => 'present',
              'gid'    => 1000,
              'name'   => 'alice',
            },
          )
        end

        it { is_expected.to contain_common__mkdir_p('/home/alice') }
        it { is_expected.to contain_exec('mkdir_p-/home/alice') } # only needed for 100% resource coverage

        it do
          is_expected.to contain_file('/home/alice').only_with(
            {
              'owner'  => 'alice',
              'group'  => 'alice',
              'mode'   => '0700',
             'require' => 'Common::Mkdir_p[/home/alice]',
            },
          )
        end

        it do
          is_expected.to contain_file('/home/alice/.ssh').only_with(
            {
              'ensure'  => 'directory',
              'mode'    => '0700',
              'owner'   => 'alice',
              'group'   => 'alice',
              'require' => 'User[alice]',
            },
          )
        end

        it { is_expected.not_to contain_ssh_authorized_key('alice') }
      end

      context 'with uid set to valid value' do
        let(:params) { { uid: 242 } }

        it { is_expected.to contain_user('alice').with_uid(242) }
        it { is_expected.to contain_user('alice').with_gid(242) }
      end

      context 'with gid set to valid value' do
        let(:params) { { uid: 1000, gid: 242 } }

        it { is_expected.to contain_user('alice').with_gid(242) }
        it { is_expected.to contain_group('alice').with_gid(242) }
      end

      context 'with shell set to valid value' do
        let(:params) { { uid: 1000, shell: '/test/ing' } }

        it { is_expected.to contain_user('alice').with_shell('/test/ing') }
      end

      context 'with home set to valid value' do
        let(:params) { { uid: 1000, home: '/test/ing' } }

        it { is_expected.to contain_user('alice').with_home('/test/ing') }
        it { is_expected.to contain_common__mkdir_p('/test/ing') }
        it { is_expected.to contain_file('/test/ing').with_require('Common::Mkdir_p[/test/ing]') }
        it { is_expected.to contain_exec('mkdir_p-/test/ing') } # only needed for 100% resource coverage
        it { is_expected.to contain_file('/test/ing/.ssh') }
      end

      context 'with home set to valid value when ssh_auth_key is true' do
        let(:params) { { uid: 1000, home: '/test/ing', ssh_auth_key: 'not-tested' } }

        it { is_expected.to contain_ssh_authorized_key('alice').with_require('File[/test/ing/.ssh]') }
      end

      context 'with ensure set to valid value' do
        let(:params) { { uid: 1000, ensure: 'absent' } }

        it { is_expected.to contain_user('alice').with_ensure('absent') }
      end

      context 'with managehome set to valid false' do
        let(:params) { { uid: 1000, managehome: false } }

        it { is_expected.to contain_user('alice').with_managehome(false) }
        it { is_expected.not_to contain_common__mkdir_p('/home/alice') }
        it { is_expected.not_to contain_file('/home/alice') }
        it { is_expected.not_to contain_file('/home/alice/.ssh') }
      end

      context 'with manage_dotssh set to valid false' do
        let(:params) { { uid: 1000, manage_dotssh: false } }

        it { is_expected.not_to contain_file('/home/alice/.ssh') }
      end

      context 'with comment set to valid value' do
        let(:params) { { uid: 1000, comment: 'testing' } }

        it { is_expected.to contain_user('alice').with_comment('testing') }
      end

      context 'with groups set to valid value' do
        let(:params) { { uid: 1000, groups: ['testing'] } }

        it { is_expected.to contain_user('alice').with_groups(['testing']) }
      end

      context 'with password set to valid value' do
        let(:params) { { uid: 1000, password: 'testing' } }

        it { is_expected.to contain_user('alice').with_password('testing') }
      end

      context 'with mode set to valid value' do
        let(:params) { { uid: 1000, mode: '0242' } }

        it { is_expected.to contain_file('/home/alice').with_mode('0242') }
      end

      context 'with ssh_auth_key set to valid value' do
        let(:params) { { uid: 1000, ssh_auth_key: 'testing' } }

        it { is_expected.to contain_ssh_authorized_key('alice').with_key('testing') }
      end

      context 'with create_group set to valid false' do
        let(:params) { { uid: 1000, create_group: false } }

        it { is_expected.not_to contain_group('alice') }
      end

      context 'with ssh_auth_key_type set to valid value' do
        let(:params) { { uid: 1000, ssh_auth_key_type: 'testing' } }

        it { is_expected.not_to contain_ssh_authorized_key('alice') }
      end

      context 'with ssh_auth_key_type set to valid value when ssh_auth_key is valid' do
        let(:params) { { uid: 1000, ssh_auth_key_type: 'testing', ssh_auth_key: 'not-tested' } }

        it { is_expected.to contain_ssh_authorized_key('alice').with_type('testing') }
      end

      context 'with purge_ssh_keys set to valid true' do
        let(:params) { { uid: 1000, purge_ssh_keys: false } }

        it { is_expected.to contain_user('alice').with_purge_ssh_keys(false) }
      end

      describe 'variable type and content validations' do
        let(:validation_params) { { uid: 1000 } }

        validations = {
          'Boolean' => {
            name:    ['managehome', 'manage_dotssh', 'create_group', 'purge_ssh_keys'],
            valid:   [true, false],
            invalid: ['invalid', ['array'], { 'ha' => 'sh' }, 3, 2.42, nil],
            message: 'expects a Boolean',
          },
          'Enum[present, absent]' => {
            name:    ['ensure'],
            valid:   ['present', 'absent'],
            invalid: ['invalid', ['array'], { 'ha' => 'sh' }, -1, 2.42, false],
            message: 'expects a match for Enum',
          },
          'Integer' => {
            name:    ['uid'],
            valid:   [0, 1, 23],
            invalid: ['string', ['array'], { 'ha' => 'sh' }, 2.42, false],
            message: 'expects an Integer',
          },
          'Optional[Array]' => {
            name:    ['groups'],
            valid:   [['array', 'of', 'strings']],
            invalid: ['string', { 'ha' => 'sh' }, 3, 2.42, false],
            message: 'expects a value of type Undef or Array',
          },
          'Optional[Integer]' => {
            name:    ['gid'],
            valid:   [0, 1, 23],
            invalid: ['string', ['array'], { 'ha' => 'sh' }, 2.42, false],
            message: 'expects a value of type Undef or Integer',
          },
          'Optional[Stdlib::Absolutepath]' => {
            name:    ['home'],
            valid:   ['/home/alice'],
            invalid: ['../invalid', ['array'], { 'ha' => 'sh' }, 3, 2.42, false],
            message: 'expects a Stdlib::Absolutepath',
          },
          'Optional[String]' => {
            name:    ['group', 'password', 'ssh_auth_key', 'ssh_auth_key_type'],
            valid:   ['string', :undef],
            invalid: [['array'], { 'ha' => 'sh' }, 3, 2.42, false],
            message: 'expects a value of type Undef or String',
          },
          'Stdlib::Absolutepath' => {
            name:    ['shell'],
            valid:   ['/home/alice'],
            invalid: ['../invalid', ['array'], { 'ha' => 'sh' }, 3, 2.42, false],
            message: 'expects a Stdlib::Absolutepath',
          },
          'Stdlib::Filemode' => {
            name:    ['mode'],
            valid:   ['0644', '0755', '0640', '1740'],
            invalid: [2770, '0844', '00644', 'string', ['array'], { 'ha' => 'sh' }, 3, 2.42, false],
            message: 'expects a match for Stdlib::Filemode',
          },
          'String' => {
            name:    ['comment'],
            valid:   ['string'],
            invalid: [['array'], { 'ha' => 'sh' }, 3, 2.42, false],
            message: 'expects a String value',
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
  end
end
