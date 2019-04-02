Puppet::Type.newtype(:mkdirp) do
   ensurable

   newparam(:name) do
     desc "name of the directory"
     isnamevar
   end

   newparam(:path) do
     desc "path to the dircetory"
     validate do |value|
       unless value[0] == '/'
         raise ArgumentError, "%s is not a absolute path" % value
       end
     end
   end

   newparam(:owner) do
     desc "owner of the dircetory"
     validate do |value|
       unless value =~ /^\w+/
         raise ArgumentError, "%s is not a valid user name" % value
       end
     end
   end

   newparam(:group) do
     desc "group of the dircetory"
     validate do |value|
       unless value =~ /^\w+/
         raise ArgumentError, "%s is not a valid group name" % value
       end
     end
   end

   newparam(:mode) do
     desc "mode of the dircetory"
   end

   newparam(:recurse) do
     desc "sets the permissons for n parent folders"
   end
end
