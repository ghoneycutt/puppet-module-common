module Puppet::Parser::Functions
  newfunction(:interface2factname, type: :rvalue, doc: <<-EOS
    Takes one argument, the interface name, and returns it formatted for use
    with facter. Example: interface2factname(bond0:0) would return 'ipaddress_bond0_0'
    EOS
  ) do |args|
    if args.size != 1
      raise(Puppet::ParseError, 'interface2factname(): Wrong number of arguments ' "given (#{args.size} for 1)")
    end

    interface = "ipaddress_#{args[0]}"
    interface.gsub(%r{[^a-z0-9_]}i, '_')
  end
end
