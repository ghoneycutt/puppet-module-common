# == Define: common::mkuser
#
# mkuser creates a user/group that can be realized in the module that employs it
#
# Copyright 2007-2013 Garrett Honeycutt
# contact@garretthoneycutt.com - Licensed GPLv2
#
# Parameters:
#   $uid               - UID of user
#   $gid               - GID of user, defaults to UID
#   $group             - group name of user, defaults to username
#   $shell             - user's shell, defaults to '/bin/bash'
#   $home              - home directory, defaults to /home/<username>
#   $ensure            - present by default
#   $managehome        - true by default
#   $manage_dotssh     - true by default. creates ~/.ssh
#   $comment           - comment field for passwd
#   $groups            - additional groups the user should be associated with
#   $password          - defaults to '!!'
#   $mode              - mode of home directory, defaults to 0700
#   $ssh_auth_key      - ssh key of the user
#   $ssh_auth_key_type - defaults to 'ssh-dss'
#
# Actions: creates a user/group
#
# Requires:
#   $uid
#
# Sample Usage:
#   # create apachehup user and realize it
#   @mkuser { 'apachehup':
#       uid        => '32001',
#       home       => '/home/apachehup',
#       comment    => 'Apache Restart User',
#   } # @mkuser
#
#   realize Common::Mkuser[apachehup]
#
define common::mkuser (
  $uid,
  $gid               = undef,
  $group             = undef,
  $shell             = undef,
  $home              = undef,
  $ensure            = 'present',
  $managehome        = true,
  $manage_dotssh     = true,
  $comment           = 'created via puppet',
  $groups            = undef,
  $password          = undef,
  $mode              = undef,
  $ssh_auth_key      = undef,
  $create_group      = true,
  $ssh_auth_key_type = undef,
  $purge_ssh_keys    = undef,
  $old_puppetmaster  = false,
) {

  if $shell {
    $myshell = $shell
  } else {
    $myshell = '/bin/bash'
  }

  # if gid is unspecified, match with uid
  if $gid {
    $mygid = $gid
  } else {
    $mygid = $uid
  } # fi $gid

  # if groups is unspecified, match with name
  if $groups {
    $mygroups = $groups
  } else {
    $mygroups = $name
  }

  # if group is unspecified, use the username
  if $group {
    $mygroup = $group
  } else {
    $mygroup = $name
  }

  if $password {
    $mypassword = $password
  } else {
    $mypassword = '!!'
  }

  # if home is unspecified, use /home/<username>
  if $home {
    $myhome = $home
  } else {
    $myhome = "/home/${name}"
  }

  # if mode is unspecified, use 0700, which is the default when you enable the
  # managehome attribute.
  if $mode {
    $mymode = $mode
  } else {
    $mymode = '0700'
  }

  if $purge_ssh_keys != undef {
    $mypurgekey = str2bool($purge_ssh_keys)
    validate_bool($mypurgekey)
  } else {
    $mypurgekey = false
  }

  # validate type and convert string to boolean if necessary
  if is_string($old_puppetmaster) {
    $old_puppetmaster_real = str2bool($old_puppetmaster)
  } else {
    $old_puppetmaster_real = $old_puppetmaster
  }

  if $old_puppetmaster_real == false {
    if versioncmp($::puppetversion, '3.6') > 0 {
      User {
        purge_ssh_keys => $mypurgekey,
      }
    }
  }

  # create user
  user { $name:
    ensure     => $ensure,
    uid        => $uid,
    gid        => $mygid,
    shell      => $myshell,
    groups     => $mygroups,
    password   => $mypassword,
    managehome => $managehome,
    home       => $myhome,
    comment    => $comment,
  } # user

  if $create_group {
    group { $name:
      ensure => $ensure,
      gid    => $mygid,
      name   => $mygroup,
    } # group
  }

  # If managing home, then set the mode of the home directory. This allows for
  # modes other than 0700 for $HOME.
  if $managehome == true {
    file { $myhome:
      owner => $name,
      mode  => $mymode,
    }
  }

  # ensure manage_dotssh is boolean
  if is_bool($manage_dotssh){
    $my_manage_dotssh = $manage_dotssh
  } elsif is_string($manage_dotssh) {
    $my_manage_dotssh = str2bool($manage_dotssh)
  } else {
    fail("${name}::manage_dotssh must be boolean or string.")
  }

  # create ~/.ssh
  case $my_manage_dotssh {
    true: {
      file { "${myhome}/.ssh":
        ensure  => directory,
        mode    => '0700',
        owner   => $name,
        group   => $name,
        require => User[$name],
      } # file
    } # 'ensure' or true
    false: {
      # noop
    }
    default: {
      fail("${name}::manage_dotssh is <${manage_dotssh}> and must be true or false")
    }
  } # case

  # if ssh_auth_key_type is unspecified, use ssh-dss
  if $ssh_auth_key_type {
    $my_ssh_auth_key_type = $ssh_auth_key_type
  } else {
    $my_ssh_auth_key_type = 'ssh-dss'
  }

  # if we specify a key, then it should be present
  if $ssh_auth_key {
    ssh_authorized_key { $name:
      ensure  => present,
      user    => $name,
      key     => $ssh_auth_key,
      type    => $my_ssh_auth_key_type,
      require => File["${myhome}/.ssh"],
    }
  }
}
