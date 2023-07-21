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
  Integer                        $gid               = $uid,
  String[1]                      $group             = $name,
  Stdlib::Absolutepath           $shell             = '/bin/bash',
  Stdlib::Absolutepath           $home              = "/home/${name}",
  Enum['present', 'absent']      $ensure            = 'present',
  Boolean                        $managehome        = true,
  Boolean                        $manage_dotssh     = true,
  String[1]                      $comment           = 'created via puppet',
  Array                          $groups            = [$name],
  String[1]                      $password          = '!!',
  Stdlib::Filemode               $mode              = '0700',
  Optional[String[1]]            $ssh_auth_key      = undef,
  Boolean                        $create_group      = true,
  String[1]                      $ssh_auth_key_type = 'ssh-dss',
  Boolean                        $purge_ssh_keys    = false,
) {
  # create user
  user { $name:
    ensure         => $ensure,
    uid            => $uid,
    gid            => $gid,
    shell          => $shell,
    groups         => $groups,
    password       => $password,
    managehome     => $managehome,
    home           => $home,
    comment        => $comment,
    purge_ssh_keys => $purge_ssh_keys,
  } # user

  if $create_group {
    # If the group is not already defined, ensure its existence
    if !defined(Group[$name]) {
      group { $name:
        ensure => $ensure,
        gid    => $gid,
        name   => $group,
      }
    }
  }

  # If managing home, then set the mode of the home directory. This allows for
  # modes other than 0700 for $HOME.
  if $managehome == true {
    common::mkdir_p { $home: }

    file { $home:
      owner   => $name,
      group   => $group,
      mode    => $mode,
      require => Common::Mkdir_p[$home],
    }

    # create ~/.ssh
    if $manage_dotssh == true {
      file { "${home}/.ssh":
        ensure  => directory,
        mode    => '0700',
        owner   => $name,
        group   => $name,
        require => User[$name],
      }
    }
  }

  # if we specify a key, then it should be present
  if $ssh_auth_key {
    ssh_authorized_key { $name:
      ensure  => present,
      user    => $name,
      key     => $ssh_auth_key,
      type    => $ssh_auth_key_type,
      require => File["${home}/.ssh"],
    }
  }
}
