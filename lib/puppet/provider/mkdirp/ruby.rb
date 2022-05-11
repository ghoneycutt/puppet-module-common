require 'fileutils'
require 'etc'

Puppet::Type.type(:mkdirp).provide(:mkdirp) do

  confine :osfamily => [:RedHat]
  confine :operatingsystemmajrelease => [5, 6]

  def create
    if resource[:path]
      then
      $path = resource[:path]
    else
      $path = resource[:name]
    end

    if resource[:owner]
      then
      $owner = resource[:owner]
    else
      $owner = 'root'
    end

    if resource[:group]
      then
      $group = resource[:group]
    else
      $group = 'root'
    end

    if resource[:mode]
      then
      $mode = resource[:mode].to_i(8)
    else
      $mode = 0755
    end

    if resource[:recurse]
      then
      $recurse = resource[:recurse].to_i
    else
      $recurse = 1
    end

    unless File.directory? $path
      FileUtils.mkdir_p($path)
    end

    $parent = $path
    if $parent[0] != '/'
      raise ArgumentError, "%s is not a absolute path" % parent
    end

    for i in 1..$recurse
      if $parent.count('/') == 1
        raise ArgumentError, "please check the recurse number, this would change permissions for %s" % $parent
      end
      FileUtils.chown($owner, $group, $parent)
      FileUtils.chmod($mode, $parent)
      $parent = File.expand_path("..", $parent)
    end
  end

  def exists?
    if resource[:path]
      then
      $path = resource[:path]
    else
      $path = resource[:name]
    end

    if resource[:owner]
      then
      $owner = resource[:owner]
    else
      $owner = 'root'
    end

    if resource[:group]
      then
      $group = resource[:group]
    else
      $group = 'root'
    end

    if resource[:mode]
      then
      $mode = resource[:mode]
    else
      $mode = '0755'
    end

    if resource[:recurse]
      then
      $recurse = resource[:recurse].to_i
    else
      $recurse = 1
    end

    if File.directory?($path)
      $file_ex = true
    else
      return false
    end

    $parent = $path
    if $parent[0] != '/'
      raise ArgumentError, "%s is not a absolute path" % parent
    end

    for i in 1..$recurse
      if Etc.getpwuid(File.stat($parent).uid).name == $owner
        $owner_ex = true
      else
        $owner_ex = false
      end

      if Etc.getgrgid(File.stat($parent).gid).name == $group
        $group_ex = true
      else
        $group_ex = false
      end

      if File.stat($parent).mode.to_s(8)[1..4] == $mode
        $mode_ex = true
      else
        $mode_ex = false
      end
      $parent = File.expand_path('..', $parent)
    end

    if $file_ex == true and $owner_ex == true and $group_ex == true and $mode_ex == true
      return true
    else
      return false
    end
  end

  def destroy
    if resource[:path]
      then
      $path = resource[:path]
    else
      $path = resource[:name]
    end
    FileUtils.rm_rf($path)
  end
end
