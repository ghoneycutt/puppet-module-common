require 'spec_helper'
describe 'common' do

  describe 'class common' do

    context 'default options with supported OS' do
      let(:facts) { {:osfamily => 'RedHat' } }
      it {
        should include_class('common')
      }
    end

    context 'default options with unsupported osfamily, Gentoo, should fail' do
      let(:facts) { {:osfamily => 'Gentoo' } }
      it do
        expect {
          should include_class('common')
        }.to raise_error(Puppet::Error,/Supported OS families are Debian, RedHat, Solaris, and Suse. Detected osfamily is Gentoo./)
      end
    end

    describe 'managing root password' do
      context 'manage_root_password => true with default root_password' do
        let(:facts) { {:osfamily => 'RedHat' } }
        let(:params) { {:manage_root_password => true } }
        it {
          should include_class('common')
          should contain_user('root').with({
            'password' => '$1$cI5K51$dexSpdv6346YReZcK2H1k.',
          })
        }
      end

      context 'manage_root_password => true and root_password => foo' do
        let(:facts) { {:osfamily => 'RedHat' } }
        let(:params) { {:manage_root_password => true, :root_password => 'foo' } }
        it {
          should include_class('common')
          should contain_user('root').with({
            'password' => 'foo',
          })
        }
      end
    end

    describe 'managing /opt/$lanana' do
      context 'create_opt_lsb_provider_name_dir => true and lsb_provider_name => UNSET [default]' do
        let(:facts) { {:osfamily => 'RedHat' } }
        let(:params) { {:create_opt_lsb_provider_name_dir=> true, :lsb_provider_name => 'UNSET' } }
        it {
          should include_class('common')
          should_not contain_file('/opt/UNSET')
        }
      end

      context 'create_opt_lsb_provider_name_dir => true and lsb_provider_name => foo' do
        let(:facts) { {:osfamily => 'RedHat' } }
        let(:params) { {:create_opt_lsb_provider_name_dir=> true, :lsb_provider_name => 'foo' } }
        it {
          should include_class('common')
          should contain_file('/opt/foo').with({
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          })
        }
      end
    end

    describe 'manage users' do
      context 'one user with default values' do

        $user_single_def = {
          'user' => {
            'uid' => 1000,
          }
        }

        let(:facts) { { :osfamily => 'RedHat' } }
        let(:params) { { :users => {
          'user' => {
            'uid' => 1000,
          }
        } } }

        it do
          should contain_user('user').with_uid(1000)
        end
        it do
          should contain_user('user').with_gid(1000)
        end
        it do
          should contain_user('user').with_shell('/bin/bash')
        end
        it do
          should contain_user('user').with_home('/home/user')
        end
        it do
          should contain_user('user').with_ensure('present')
        end
        it do
          should contain_user('user').with_groups('user')
        end
        it do
          should contain_user('user').with_password('!!')
        end
        it do
          should contain_user('user').with_managehome(true)
        end
        it do
          should contain_user('user').with_comment('created via puppet')
        end
        it do
          should contain_file('/home/user').with({
            'owner'  => 'user',
            'mode'   => '0700',
          })
        end
        it do
          should contain_file('/home/user/.ssh').with({
            'ensure' => 'directory',
            'mode'   => '0700',
            'owner'  => 'user',
            'group'  => 'user',
          })
        end
        it do
          should contain_group('user').with({
            'ensure' => 'present',
            'gid'    => 1000,
            'name'   => 'user',
          })
        end
      end

      context 'one user with custom values' do

        let(:facts) { { :osfamily => 'RedHat' } }
        let(:params) { { :users =>  {
          'myuser' => {
            'uid'      => 2000,
            'group'    => 'superusers',
            'gid'      => 2000,
            'shell'    => '/bin/zsh',
            'home'     => '/home/superu',
            'groups'   => ['superusers', 'development', 'admins'],
            'password' => 'puppet',
            'mode'     => '0701',
            'comment'  => 'a puppet master'
          }
        } } }

        it do
          should contain_user('myuser').with_uid(2000)
        end
        it do
          should contain_user('myuser').with_gid(2000)
        end
        it do
          should contain_user('myuser').with_shell('/bin/zsh')
        end
        it do
          should contain_user('myuser').with_home('/home/superu')
        end
        it do
          should contain_user('myuser').with_groups(['superusers', 'development', 'admins'])
        end
        it do
          should contain_user('myuser').with({ 'password' => 'puppet' })
        end
        it do
          should contain_user('myuser').with_comment('a puppet master')
        end
        it do
          should contain_file('/home/superu').with({
            'owner'  => 'myuser',
            'mode'   => '0701',
          })
        end
        it do
          should contain_file('/home/superu/.ssh').with({
            'ensure' => 'directory',
            'mode'   => '0700',
            'owner'  => 'myuser',
            'group'  => 'myuser',
          })
        end
      end

      context 'two users with default values' do

        let(:facts) { { :osfamily => 'RedHat' } }
        let(:params) { { :users => {
           'user1' => {
             'uid' => 1000,
           },
           'user2' => {
            'uid' => 1001,
          }
        } } }

        it do
          should contain_user('user1').with({
            'uid'        => 1000,
            'gid'        => 1000,
            'shell'      => '/bin/bash',
            'home'       => '/home/user1',
            'ensure'     => 'present',
            'managehome' => true,
            'groups'     => 'user1',
            'password'   => '!!',
            'comment'    => 'created via puppet',
          })
        end
        it do
          should contain_user('user2').with({
            'uid'        => 1001,
            'gid'        => 1001,
            'shell'      => '/bin/bash',
            'home'       => '/home/user2',
            'ensure'     => 'present',
            'managehome' => true,
            'groups'     => 'user2',
            'password'   => '!!',
            'comment'    => 'created via puppet',
          })
        end

        it do
          should contain_file('/home/user1').with({
            'owner'  => 'user1',
            'mode'   => '0700',
          })
          should contain_file('/home/user2').with({
            'owner'  => 'user2',
            'mode'   => '0700',
          })
        end
        it do
          should contain_file('/home/user1/.ssh').with({
            'ensure' => 'directory',
            'mode'   => '0700',
            'owner'  => 'user1',
            'group'  => 'user1',
          })
          should contain_file('/home/user2/.ssh').with({
            'ensure' => 'directory',
            'mode'   => '0700',
            'owner'  => 'user2',
            'group'  => 'user2',
          })
        end
        it do
          should contain_group('user1').with({
            'ensure' => 'present',
            'gid'    => 1000,
            'name'   => 'user1',
          })
          should contain_group('user2').with({
            'ensure' => 'present',
            'gid'    => 1001,
            'name'   => 'user2',
          })
        end
      end
      context 'don\'t manage home' do

        let(:facts) { { :osfamily => 'RedHat' } }
        let(:params) { { :users => {
          'user' => {
            'uid'        => 1000,
            'managehome' => false
          }
        } } }

        it do
          should_not contain_file('/home/user')
        end
        it do
          should contain_user('user').with_managehome(false)
        end
      end
      context 'don\'t manage dotssh' do

        let(:facts) { { :osfamily => 'RedHat' } }
        let(:params) { { :users => {
          'user' => {
            'uid'           => 1000,
            'manage_dotssh' => false
          }
        } } }

        it do
          should_not contain_file('/home/user/.ssh')
        end
      end
    end
  end
end
