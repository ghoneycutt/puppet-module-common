module Puppet::Parser::Functions
  newfunction(:strip_file_extension, type: :rvalue, doc: <<-EOS
    Takes two arguments, a file name which can include the path, and the
    extension to be removed. Returns the file name without the extension
    as a string.
    EOS
  ) do |args|
    if args.size != 2
      raise(Puppet::ParseError, 'strip_file_extension(): Wrong number of arguments ' "given (#{args.size} for 2)")
    end

    filename = args[0]

    # allow the extension to optionally start with a period.
    extension = if %r{^\.}.match?(args[1])
                  args[1]
                else
                  ".#{args[1]}"
                end

    File.basename(filename, extension)
  end
end
