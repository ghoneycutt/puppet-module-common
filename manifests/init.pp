# @summary Common module to be applied to **ALL** nodes
#   === Compatibility
#   Module is generic enough to work on any system, though the individual
#   modules that it could potentially include could be very platform specific.
#
#   === Copyright
#   Copyright 2013 GH Solutions, LLC
#
# @param users
#   Hash of users to ensure with common::mkusers.
#
# @param groups
#   Hash of groups to ensure.
#
# @param manage_root_password
#   If root password should be managed.
#
# @param root_password
#   MD5 crypt of `puppet`.
#
# @param create_opt_lsb_provider_name_dir
#   Boolean to ensure `/opt/${lsb_provider_name}`.
#
# @param lsb_provider_name
#   LSB Provider Name as assigned by LANANA
#   [http://www.lanana.org/lsbreg/providers/index.html](http://www.lanana.org/lsbreg/providers/index.html)
#
# @param enable_dnsclient
#   Boolean to include ghoneycutt/dnsclient.
#
# @param enable_hosts
#   Boolean to include ghoneycutt/hosts.
#
# @param enable_inittab
#   Boolean to include ghoneycutt/inittab.
#
# @param enable_mailaliases
#   Boolean to include ghoneycutt/mailaliases.
#
# @param enable_motd
#   Boolean to include ghoneycutt/motd.
#
# @param enable_network
#   Boolean to include ghoneycutt/network.
#
# @param enable_nsswitch
#   Boolean to include ghoneycutt/nsswitch.
#
# @param enable_ntp
#   Boolean to include ghoneycutt/ntp.
#
# @param enable_pam
#   Boolean to include ghoneycutt/pam.
#
# @param enable_puppet_agent
#   Boolean to include ghoneycutt/puppet::agent.
#
# @param enable_rsyslog
#   Boolean to include ghoneycutt/rsyslog.
#
# @param enable_selinux
#   Boolean to include ghoneycutt/selinux.
#
# @param enable_ssh
#   Boolean to include ghoneycutt/ssh.
#
# @param enable_utils
#   Boolean to include ghoneycutt/utils.
#
# @param enable_vim
#   Boolean to include ghoneycutt/vim.
#
# @param enable_wget
#   Boolean to include ghoneycutt/wget.
#
# @param enable_debian
#   Boolean to include ghoneycutt/debian.
#
# @param enable_redhat
#   Boolean to include ghoneycutt/redhat.
#
# @param enable_solaris
#   Boolean to include ghoneycutt/solaris.
#
# @param enable_suse
#   Boolean to include ghoneycutt/suse.
#
class common (
  Optional[Hash] $users                            = undef,
  Optional[Hash] $groups                           = undef,
  Boolean        $manage_root_password             = false,
  String[1]      $root_password                    = '$1$cI5K51$dexSpdv6346YReZcK2H1k.', # puppet
  Boolean        $create_opt_lsb_provider_name_dir = false,
  String[1]      $lsb_provider_name                = 'UNSET',
  Boolean        $enable_dnsclient                 = false,
  Boolean        $enable_hosts                     = false,
  Boolean        $enable_inittab                   = false,
  Boolean        $enable_mailaliases               = false,
  Boolean        $enable_motd                      = false,
  Boolean        $enable_network                   = false,
  Boolean        $enable_nsswitch                  = false,
  Boolean        $enable_ntp                       = false,
  Boolean        $enable_pam                       = false,
  Boolean        $enable_puppet_agent              = false,
  Boolean        $enable_rsyslog                   = false,
  Boolean        $enable_selinux                   = false,
  Boolean        $enable_ssh                       = false,
  Boolean        $enable_utils                     = false,
  Boolean        $enable_vim                       = false,
  Boolean        $enable_wget                      = false,
  # include classes based on osfamily fact
  Boolean        $enable_debian                    = false,
  Boolean        $enable_redhat                    = false,
  Boolean        $enable_solaris                   = false,
  Boolean        $enable_suse                      = false,
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
  case $::facts['os']['family'] {
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
      fail("Supported OS families are Debian, RedHat, Solaris, and Suse. Detected osfamily is ${::facts['os']['family']}.")
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

  if $users != undef {
    # Create virtual user resources
    create_resources('@common::mkuser',$common::users)

    # Collect all virtual users
    Common::Mkuser <||> # lint:ignore:spaceship_operator_without_tag
  }

  if $groups != undef {
    # Create virtual group resources
    create_resources('@group',$common::groups)

    # Collect all virtual groups
    Group <||> # lint:ignore:spaceship_operator_without_tag
  }
}
