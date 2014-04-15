# == Define: common::mkdir_p
#
# Provide `mkdir -p` functionality for a directory
#
# Idea is to use this mkdirp in conjunction with a file resource
#
# Example usage:
#
#   mkdirp { 'example_dir':
#     ensure  => present,
#     path    => '/tmp/path/to/the/dir',
#     owner   => 'root',
#     group   => 'root',
#     mode    => '0755',
#     recurse => '2',
#   } # the recurse param sets the permissions for n-parent folders
#
#   file { 'example_file':
#     ensure  => 'present',
#     path    => '/tmp/path/to/the/dir/filename',
#     require => Mkdirp['example_dir'],
#   }

# a known bug:
# if a value gets updated puppet will show this as "created"
#
# Notice: /Stage[main]/Mkdirp/Mkdirp[example_dir]/ensure: created
