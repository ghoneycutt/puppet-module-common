# @summary
#   Provide `mkdir -p` functionality for a directory
#
#   Idea is to use this mkdir_p in conjunction with a file resource
#
#   Example usage:
#
#    common::mkdir_p { '/some/dir/structure': }
#
#    file { '/some/dir/structure':
#      ensure  => directory,
#      require => Common::Mkdir_p['/some/dir/structure'],
#    }
#
# @param path
#   Absolute path to be created
#
define common::mkdir_p (
  Stdlib::Absolutepath $path = $name,
) {
  exec { "mkdir_p-${path}":
    command => "mkdir -p ${path}",
    unless  => "test -d ${path}",
    path    => '/bin:/usr/bin',
  }
}
