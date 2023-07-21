# @summary
#   Removes a file if it exists and is empty.
#
#   Example usage:
#
#   common::remove_if_empty { '/path/to/potentially_empty_file': }
#
# @param path
#   Absolute path to be tested for emptyness and then be removed
#
define common::remove_if_empty (
  Stdlib::Absolutepath $path = $name,
) {
  exec { "remove_if_empty-${path}":
    command => "rm -f ${path}",
    unless  => "test -f ${path}; if [ $? == '0' ]; then test -s ${path}; fi",
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
  }
}
