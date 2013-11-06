module Puppet::Parser::Functions
  newfunction(:is_true, :type => :rvalue, :doc => <<-EOS
Returns true if the variable is true or str2bool(variable) is true.
    EOS
  ) do |arguments|
    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_true(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    value = arguments[0]
    Puppet::Parser::Functions.function('type')
    Puppet::Parser::Functions.function('str2bool')
    type = function_type( [ value ] )

    if type == "string" then
      return function_str2bool( [ value ] )
    elsif type == "boolean"
      return value
    else
      raise(Puppet::ParseError, 'is_true(): Unknown type, not a string or boolean')
    end
  end
end
