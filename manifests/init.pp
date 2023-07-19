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
  if $enable_dnsclient == true {
    include dnsclient
  }

  if $enable_hosts == true {
    include hosts
  }

  if $enable_inittab == true {
    include inittab
  }

  if $enable_mailaliases == true {
    include mailaliases
  }

  if $enable_motd == true {
    include motd
  }

  if $enable_network == true {
    include network
  }

  if $enable_nsswitch == true {
    include nsswitch
  }

  if $enable_ntp == true {
    include ntp
  }

  if $enable_pam == true {
    include pam
  }

  if $enable_puppet_agent == true {
    include puppet::agent
  }

  if $enable_rsyslog == true {
    include rsyslog
  }

  if $enable_selinux == true {
    include selinux
  }

  if $enable_ssh == true {
    include ssh
  }

  if $enable_utils == true {
    include utils
  }

  if $enable_vim == true {
    include vim
  }

  if $enable_wget == true {
    include wget
  }

  # only allow supported OS's
  case $::facts['os']['family'] {
    'debian': {
      if $enable_debian == true {
        include debian
      }
    }
    'redhat': {
      if $enable_redhat == true {
        include redhat
      }
    }
    'solaris': {
      if $enable_solaris == true {
        include solaris
      }
    }
    'suse': {
      if $enable_suse == true {
        include suse
      }
    }
    default: {
      fail("Supported OS families are Debian, RedHat, Solaris, and Suse. Detected osfamily is ${::facts['os']['family']}.")
    }
  }

  if $manage_root_password == true {
    user { 'root':
      password => $root_password,
    }
  }

  if $create_opt_lsb_provider_name_dir == true {
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
