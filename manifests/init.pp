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
  # include classes based on osfamily fact
  $enable_debian                    = false,
  $enable_redhat                    = false,
  $enable_solaris                   = false,
  $enable_suse                      = false,
  $users_old_puppetmaster           = false,
) {

  # validate type and convert string to boolean if necessary
  if is_string($enable_dnsclient) {
    $dnsclient_enabled = str2bool($enable_dnsclient)
  } else {
    $dnsclient_enabled = $enable_dnsclient
  }
  if $dnsclient_enabled == true {
    include dnsclient
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_hosts) {
    $hosts_enabled = str2bool($enable_hosts)
  } else {
    $hosts_enabled = $enable_hosts
  }
  if $hosts_enabled == true {
    include hosts
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_inittab) {
    $inittab_enabled = str2bool($enable_inittab)
  } else {
    $inittab_enabled = $enable_inittab
  }
  if $inittab_enabled == true {
    include inittab
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_mailaliases) {
    $mailaliases_enabled = str2bool($enable_mailaliases)
  } else {
    $mailaliases_enabled = $enable_mailaliases
  }
  if $mailaliases_enabled == true {
    include mailaliases
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_mailaliases) {
    $motd_enabled = str2bool($enable_motd)
  } else {
    $motd_enabled = $enable_motd
  }
  if $motd_enabled == true {
    include motd
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_network) {
    $network_enabled = str2bool($enable_network)
  } else {
    $network_enabled = $enable_network
  }
  if $network_enabled == true {
    include network
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_nsswitch) {
    $nsswitch_enabled = str2bool($enable_nsswitch)
  } else {
    $nsswitch_enabled = $enable_nsswitch
  }
  if $nsswitch_enabled == true {
    include nsswitch
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_ntp) {
    $ntp_enabled = str2bool($enable_ntp)
  } else {
    $ntp_enabled = $enable_ntp
  }
  if $ntp_enabled == true {
    include ntp
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_pam) {
    $pam_enabled = str2bool($enable_pam)
  } else {
    $pam_enabled = $enable_pam
  }
  if $pam_enabled == true {
    include pam
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_puppet_agent) {
    $puppet_agent_enabled = str2bool($enable_puppet_agent)
  } else {
    $puppet_agent_enabled = $enable_puppet_agent
  }
  if $puppet_agent_enabled == true {
    include puppet::agent
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_rsyslog) {
    $rsyslog_enabled = str2bool($enable_rsyslog)
  } else {
    $rsyslog_enabled = $enable_rsyslog
  }
  if $rsyslog_enabled == true {
    include rsyslog
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_selinux) {
    $selinux_enabled = str2bool($enable_selinux)
  } else {
    $selinux_enabled = $enable_selinux
  }
  if $selinux_enabled == true {
    include selinux
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_ssh) {
    $ssh_enabled = str2bool($enable_ssh)
  } else {
    $ssh_enabled = $enable_ssh
  }
  if $ssh_enabled == true {
    include ssh
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_utils) {
    $utils_enabled = str2bool($enable_utils)
  } else {
    $utils_enabled = $enable_utils
  }
  if $utils_enabled == true {
    include utils
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_vim) {
    $vim_enabled = str2bool($enable_vim)
  } else {
    $vim_enabled = $enable_vim
  }
  if $vim_enabled == true {
    include vim
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_wget) {
    $wget_enabled = str2bool($enable_wget)
  } else {
    $wget_enabled = $enable_wget
  }
  if $wget_enabled == true {
    include wget
  }

  # only allow supported OS's
  case $::osfamily {
    'debian': {
      # validate type and convert string to boolean if necessary
      if is_string($enable_debian) {
        $debian_enabled = str2bool($enable_debian)
      } else {
        $debian_enabled = $enable_debian
      }
      if $debian_enabled == true {
        include debian
      }
    }
    'redhat': {
      # validate type and convert string to boolean if necessary
      if is_string($enable_redhat) {
        $redhat_enabled = str2bool($enable_redhat)
      } else {
        $redhat_enabled = $enable_redhat
      }
      if $redhat_enabled == true {
        include redhat
      }
    }
    'solaris': {
      # validate type and convert string to boolean if necessary
      if is_string($enable_solaris) {
        $solaris_enabled = str2bool($enable_solaris)
      } else {
        $solaris_enabled = $enable_solaris
      }
      if $solaris_enabled == true {
        include solaris
      }
    }
    'suse': {
      # validate type and convert string to boolean if necessary
      if is_string($enable_suse) {
        $suse_enabled = str2bool($enable_suse)
      } else {
        $suse_enabled = $enable_suse
      }
      if $suse_enabled == true {
        include suse
      }
    }
    default: {
      fail("Supported OS families are Debian, RedHat, Solaris, and Suse. Detected osfamily is ${::osfamily}.")
    }
  }

  # validate type and convert string to boolean if necessary
  if is_string($manage_root_password) {
    $manage_root_password_real = str2bool($manage_root_password)
  } else {
    $manage_root_password_real = $manage_root_password
  }

  if $manage_root_password_real == true {

    # validate root_password - fail if not a string
    if !is_string($root_password) {
      fail('common::root_password is not a string.')
    }

    user { 'root':
      password => $root_password,
    }
  }

  # validate type and convert string to boolean if necessary
  if is_string($create_opt_lsb_provider_name_dir) {
    $create_opt_lsb_provider_name_dir_real = str2bool($create_opt_lsb_provider_name_dir)
  } else {
    $create_opt_lsb_provider_name_dir_real = $create_opt_lsb_provider_name_dir
  }

  if $create_opt_lsb_provider_name_dir_real == true {

    # validate lsb_provider_name - fail if not a string
    if !is_string($lsb_provider_name) {
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

  # validate type and convert string to boolean if necessary
  if is_string($users_old_puppetmaster) {
    $users_old_puppetmaster_real = str2bool($users_old_puppetmaster)
  } else {
    $users_old_puppetmaster_real = $users_old_puppetmaster
  }

  if $users != undef {
    if $users_old_puppetmaster_real == true {
      $default_options = {
        'old_puppetmaster' => true,
      }
    } else {
      $default_options = {}
    }

    # Create virtual user resources
    create_resources('@common::mkuser',$common::users, $default_options)

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
