# @summary Class to manage users and groups
#   mkuser creates a user/group that can be realized in the module that employs it
#
#   Copyright 2007-2013 Garrett Honeycutt
#   contact@garretthoneycutt.com - Licensed GPLv2
#
#   Actions: creates a user/group
#
#   Requires:
#     $uid
#
#   Sample Usage:
#     # create apachehup user and realize it
#     @mkuser { 'apachehup':
#         uid        => '32001',
#         home       => '/home/apachehup',
#         comment    => 'Apache Restart User',
#     } # @mkuser
#
#     realize Common::Mkuser[apachehup]
#
# @param uid
#   UID of user.
#
# @param gid
#   GID of user.
#
# @param group
#   Group name of user.
#
# @param shell
#   Absolute path to user shell.
#
# @param home
#   Absolute path to home directory.
#
# @param ensure
#   Ensure parameter of user resource.
#
# @param managehome
#   Managehome attribute of user resource.
#
# @param manage_dotssh
#   If optional `~/.ssh` should be created.
#
# @param comment
#   GECOS field for passwd.
#
# @param groups
#   Additional groups the user should be associated with.
#
# @param password
#   Password crypt for user.
#
# @param mode
#   Mode of home directory.
#
# @param ssh_auth_key
#   Ssh key for the user.
#
# @param create_group
#   Ensure to create the group if it is not already existing.
#
# @param ssh_auth_key_type
#   Type attribute of ssh_authorized_key resource.
#
# @param purge_ssh_keys
#   purge_ssh_keys attribute of the user resource.
#   Purge any keys that aren’t managed as ssh_authorized_key resources.
#
define common::mkuser (
  Integer                        $uid,
  Optional[Integer]              $gid               = undef,
  Optional[String[1]]            $group             = undef,
  Stdlib::Absolutepath           $shell             = '/bin/bash',
  Optional[Stdlib::Absolutepath] $home              = undef,
  Enum['present', 'absent']      $ensure            = 'present',
  Boolean                        $managehome        = true,
  Boolean                        $manage_dotssh     = true,
  String[1]                      $comment           = 'created via puppet',
  Optional[Array]                $groups            = undef,
  Optional[String[1]]            $password          = undef,
  Optional[Stdlib::Filemode]     $mode              = undef,
  Optional[String[1]]            $ssh_auth_key      = undef,
  Boolean                        $create_group      = true,
  Optional[String[1]]            $ssh_auth_key_type = undef,
  Boolean                        $purge_ssh_keys    = false,
) {
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

  # ensure managehome is boolean
  if is_bool($managehome) {
    $my_managehome = $managehome
  } elsif is_string($managehome) {
    $my_managehome = str2bool($managehome)
  } else {
    fail("${name}::managehome must be boolean or string.")
  }

  # create user
  user { $name:
    ensure         => $ensure,
    uid            => $uid,
    gid            => $mygid,
    shell          => $shell,
    groups         => $mygroups,
    password       => $mypassword,
    managehome     => $my_managehome,
    home           => $myhome,
    comment        => $comment,
    purge_ssh_keys => $purge_ssh_keys,
  } # user

  if $create_group {
    # If the group is not already defined, ensure its existence
    if !defined(Group[$name]) {
      group { $name:
        ensure => $ensure,
        gid    => $mygid,
        name   => $mygroup,
      }
    }
  }

  # If managing home, then set the mode of the home directory. This allows for
  # modes other than 0700 for $HOME.
  if $my_managehome == true {
    common::mkdir_p { $myhome: }

    file { $myhome:
      owner   => $name,
      group   => $mygroup,
      mode    => $mymode,
      require => Common::Mkdir_p[$myhome],
    }

    # ensure manage_dotssh is boolean
    if is_bool($manage_dotssh) {
      $my_manage_dotssh = $manage_dotssh
    } elsif is_string($manage_dotssh) {
      $my_manage_dotssh = str2bool($manage_dotssh)
    } else {
      fail("${name}::manage_dotssh must be boolean or string.")
    }

    # create ~/.ssh
    if $my_manage_dotssh == true {
      file { "${myhome}/.ssh":
        ensure  => directory,
        mode    => '0700',
        owner   => $name,
        group   => $name,
        require => User[$name],
      }
    }
  }

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
