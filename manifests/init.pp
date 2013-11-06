# == Class: common
#
# This class is applied to *ALL* nodes
#
# === Copyright
#
# Copyright 2013 GH Solutions, LLC
#
class common (
  $users                            = undef,
  $groups                           = undef,
  $manage_root_password             = false,
  $root_password                    = '$1$cI5K51$dexSpdv6346YReZcK2H1k.', # puppet
  $create_opt_lsb_provider_name_dir = false,
  $lsb_provider_name                = 'UNSET',
  $enable_dnsclient                 = false,
  $enable_hosts                     = false,
  $enable_inittab                   = false,
  $enable_mailaliases               = false,
  $enable_motd                      = false,
  $enable_network                   = false,
  $enable_nsswitch                  = false,
  $enable_ntp                       = false,
  $enable_pam                       = false,
  $enable_puppet_agent              = false,
  $enable_rsyslog                   = false,
  $enable_selinux                   = false,
  $enable_ssh                       = false,
  $enable_utils                     = false,
  $enable_vim                       = false,
  $enable_wget                      = false,
  # include classes based on virtual or physical
  $enable_virtual                   = false,
  $enable_physical                  = false,
  # include classes based on osfamily fact
  $enable_debian                    = false,
  $enable_redhat                    = false,
  $enable_solaris                   = false,
  $enable_suse                      = false,
) {

  if is_true($enable_dnsclient) {
    include dnsclient
  }
  if is_true($enable_hosts) {
    include hosts
  }
  if is_true($enable_inittab) {
    include inittab
  }
  if is_true($enable_mailaliases) {
    include mailaliases
  }
  if is_true($enable_motd) {
    include motd
  }
  if is_true($enable_network) {
    include network
  }
  if is_true($enable_nsswitch) {
    include nsswitch
  }
  if is_true($enable_ntp) {
    include ntp
  }
  if is_true($enable_pam) {
    include pam
  }
  if is_true($enable_puppet_agent) {
    include puppet::agent
  }
  if is_true($enable_rsyslog) {
    include rsyslog
  }
  if is_true($enable_selinux) {
    include selinux
  }
  if is_true($enable_ssh) {
    include ssh
  }
  if is_true($enable_utils) {
    include utils
  }
  if is_true($enable_vim) {
    include vim
  }
  if is_true($enable_wget) {
    include wget
  }

  # only allow supported OS's
  case $::osfamily {
    'debian': {
      if is_true($enable_debian) {
        include debian
      }
    }
    'redhat': {
      if is_true($enable_redhat) {
        include redhat
      }
    }
    'solaris': {
      if is_true($enable_solaris) {
        include solaris
      }
    }
    'suse': {
      if is_true($enable_suse) {
        include suse
      }
    }
    default: {
      fail("Supported OS families are Debian, RedHat, Solaris, and Suse. Detected osfamily is ${::osfamily}.")
    }
  }

  # include modules depending on if we are virtual or not
  if is_true($::is_virtual) and is_true($enable_virtual) {
    include virtual
  } else {
    if is_true($enable_physical) {
      include physical
    }
  }

  if is_true($manage_root_password) {

    # validate root_password - fail if not a string
    $root_password_type = type($root_password)
    if $root_password_type != 'string' {
      fail('common::root_password is not a string.')
    }

    user { 'root':
      password => $root_password,
    }
  }

  if is_true($create_opt_lsb_provider_name_dir) == true {

    # validate lsb_provider_name - fail if not a string
    $lsb_provider_name_type = type($lsb_provider_name)
    if $lsb_provider_name_type != 'string' {
      fail('common::lsb_provider_name is not a string.')
    }

    if $lsb_provider_name != 'UNSET' {

      # basic filesystem requirements
      file { "/opt/${lsb_provider_name}":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }
  }

  if $users != undef {

    # Create virtual user resources
    create_resources('@common::mkuser',$common::users)

    # Collect all virtual users
    Common::Mkuser <||>
  }

  if $groups != undef {

    # Create virtual group resources
    create_resources('@group',$common::groups)

    # Collect all virtual groups
    Group <||>
  }
}
