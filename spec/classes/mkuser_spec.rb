require 'spec_helper'
describe 'common' do

  describe 'mkuser define' do
    context 'one user with default values' do

      $user_single_def = {
        'alice' => {
          'uid' => 1000,
        }
      }

      let(:facts) { { :osfamily => 'RedHat' } }
      let(:params) { { :users => {
        'alice' => {
          'uid' => 1000,
        }
      } } }

      it do
        should contain_user('alice').with_uid(1000)
      end
      it do
        should contain_user('alice').with_gid(1000)
      end
      it do
        should contain_user('alice').with_shell('/bin/bash')
      end
      it do
        should contain_user('alice').with_home('/home/alice')
      end
      it do
        should contain_user('alice').with_ensure('present')
      end
      it do
        should contain_user('alice').with_groups('alice')
      end
      it do
        should contain_user('alice').with_password('!!')
      end
      it do
        should contain_user('alice').with_managehome(true)
      end
      it do
        should contain_user('alice').with_comment('created via puppet')
      end
      it do
        should contain_file('/home/alice').with({
          'owner'  => 'alice',
          'mode'   => '0700',
        })
      end
      it do
        should contain_file('/home/alice/.ssh').with({
          'ensure' => 'directory',
          'mode'   => '0700',
          'owner'  => 'alice',
          'group'  => 'alice',
        })
      end
      it do
        should contain_group('alice').with({
          'ensure' => 'present',
          'gid'    => 1000,
          'name'   => 'alice',
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
         'alice' => {
           'uid' => 1000,
         },
         'bob' => {
          'uid' => 1001,
        }
      } } }

      it do
        should contain_user('alice').with({
          'uid'        => 1000,
          'gid'        => 1000,
          'shell'      => '/bin/bash',
          'home'       => '/home/alice',
          'ensure'     => 'present',
          'managehome' => true,
          'groups'     => 'alice',
          'password'   => '!!',
          'comment'    => 'created via puppet',
        })
      end
      it do
        should contain_user('bob').with({
          'uid'        => 1001,
          'gid'        => 1001,
          'shell'      => '/bin/bash',
          'home'       => '/home/bob',
          'ensure'     => 'present',
          'managehome' => true,
          'groups'     => 'bob',
          'password'   => '!!',
          'comment'    => 'created via puppet',
        })
      end

      it do
        should contain_file('/home/alice').with({
          'owner'  => 'alice',
          'mode'   => '0700',
        })
        should contain_file('/home/bob').with({
          'owner'  => 'bob',
          'mode'   => '0700',
        })
      end
      it do
        should contain_file('/home/alice/.ssh').with({
          'ensure' => 'directory',
          'mode'   => '0700',
          'owner'  => 'alice',
          'group'  => 'alice',
        })
        should contain_file('/home/bob/.ssh').with({
          'ensure' => 'directory',
          'mode'   => '0700',
          'owner'  => 'bob',
          'group'  => 'bob',
        })
      end
      it do
        should contain_group('alice').with({
          'ensure' => 'present',
          'gid'    => 1000,
          'name'   => 'alice',
        })
        should contain_group('bob').with({
          'ensure' => 'present',
          'gid'    => 1001,
          'name'   => 'bob',
        })
      end
    end
    context 'do not manage home' do

      let(:facts) { { :osfamily => 'RedHat' } }
      let(:params) { { :users => {
        'alice' => {
          'uid'        => 1000,
          'managehome' => false
        }
      } } }

      it do
        should_not contain_file('/home/alice')
      end
      it do
        should contain_user('alice').with_managehome(false)
      end
    end
    context 'do not manage dotssh' do

      let(:facts) { { :osfamily => 'RedHat' } }
      let(:params) { { :users => {
        'alice' => {
          'uid'           => 1000,
          'manage_dotssh' => false
        }
      } } }

      it do
        should_not contain_file('/home/alice/.ssh')
      end
    end
  end
end
