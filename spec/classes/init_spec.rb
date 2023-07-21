require 'spec_helper'
describe 'common' do
  # By default rspec-puppet-facts only provide facts for x86_64 architectures.
  # To be able to test Solaris we need to add 'i86pc' hardwaremodel.
  test_on = {
    hardwaremodels: ['x86_64', 'i386', 'i86pc']
  }

  on_supported_os(test_on).sort.each do |os, facts|
    describe "on #{os}" do
      let(:facts) { facts }

      context 'with default values for parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_resource_count(0) }
      end

      ['debian', 'redhat', 'solaris', 'suse'].sort.each do |family|
        context "with enable_#{family} set to valid true" do
          let(:params) { { "enable_#{family}": true } }
          let(:pre_condition) { "class #{family} (){}" }

          if family == facts[:os]['family'].downcase
            it { is_expected.to contain_class(family) }
          else
            it { is_expected.to have_resource_count(0) }
          end
        end
      end
    end
  end

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

      context 'with users set to valid value' do
        let(:params) { { users: { 'test' => { 'uid' => 242 } } } }

        it { is_expected.to contain_common__mkuser('test').with_uid(242) }
        it { is_expected.to contain_common__mkdir_p('/home/test') } # only needed for 100% resource coverage
        it { is_expected.to contain_exec('mkdir_p-/home/test') }    # only needed for 100% resource coverage
        it { is_expected.to contain_file('/home/test/.ssh') }       # only needed for 100% resource coverage
        it { is_expected.to contain_file('/home/test') }            # only needed for 100% resource coverage
        it { is_expected.to contain_group('test') }                 # only needed for 100% resource coverage
        it { is_expected.to contain_user('test') }                  # only needed for 100% resource coverage
      end

      context 'with groups set to valid value' do
        let(:params) { { groups: { 'test' => { 'gid' => 242 } } } }

        it { is_expected.to contain_group('test').with_gid(242) }
      end

      context 'with manage_root_password set to valid true' do
        let(:params) { { manage_root_password: true } }

        it { is_expected.to contain_user('root').with_password('$1$cI5K51$dexSpdv6346YReZcK2H1k.') }
      end

      context 'with root_password set to valid value' do
        let(:params) { { root_password: 'test' } }

        it { is_expected.not_to contain_user('root') }
        it { is_expected.to have_resource_count(0) }
      end

      context 'with root_password set to valid value when manage_root_password set to true' do
        let(:params) { { root_password: 'test', manage_root_password: true } }

        it { is_expected.to contain_user('root').with_password('test') }
      end

      context 'with create_opt_lsb_provider_name_dir set to valid true' do
        let(:params) { { create_opt_lsb_provider_name_dir: true } }

        it { is_expected.to have_resource_count(0) }
      end

      context 'with create_opt_lsb_provider_name_dir set to valid true when lsb_provider_name is set' do
        let(:params) { { create_opt_lsb_provider_name_dir: true, lsb_provider_name: 'test' } }

        it do
          is_expected.to contain_file('/opt/test').only_with(
            {
              'ensure' => 'directory',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0755',
            },
          )
        end
      end

      ['dnsclient', 'hosts', 'inittab', 'mailaliases', 'motd', 'network', 'nsswitch', 'ntp', 'pam', 'rsyslog',
       'selinux', 'ssh', 'utils', 'vim', 'wget'].sort.each do |param|
        context "with enable_#{param} set to valid true" do
          let(:params) { { "enable_#{param}": true } }
          let(:pre_condition) { "class #{param} (){}" }

          it { is_expected.to contain_class(param) }
        end
      end

      context 'with enable_puppet_agent set to valid true' do
        let(:params) { { enable_puppet_agent: true } }
        let(:pre_condition) { 'class puppet::agent (){}' }

        it { is_expected.to contain_class('puppet::agent') }
      end
    end
  end
end
