require 'facter'

Facter.add(:profile) do
  confine :kernel => %w{Linux SunOS}
  setcode do
    Facter::Util::Resolution.exec("cat /etc/eprofile")
  end
end

Facter.add(:pdu) do
  confine :kernel => %w{Linux SunOS}
  setcode do
    Facter::Util::Resolution.exec("cat /etc/epdu")
  end
end

