# This should replace the common::mkdir_p function
#
# the advantage is you can set the owner,group and permission
# for the specified directory or n-parent directories
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
