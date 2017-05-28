#!/usr/bin/env ruby
"""
Converts the IP ranges from their CIDR format into something that can be input
into an OpenVPN config.
"""

require 'ipaddr'

class IPAddr  # From 'ipaddr' in stdlib
  """Add some nicer methods to return the IP / subnet."""
  def get_ip
    self.inspect.split(/[\/:]/).slice(2)
  end

  def get_subnet
    self.inspect.split(/[\/:>]/).slice(3)
  end
end

class IPRange
  def initialize(range)
    @range = range
  end

  def is_valid_ip_range?
    """Get rid of anything that doesn't look like an IP range."""
    begin
      @range = IPAddr.new @range
    rescue IPAddr::InvalidAddressError
      return false
    end
    return true
  end

  def split_subnet
    """Turns CIDR to subnet form; 1.2.3.4/32 -> 1.2.3.4 255.255.255.255."""
    # @range.inspect.split(/[\/:>]/).slice(2,4).join(' ')
    "#{@range.get_ip} #{@range.get_subnet}"
  end

end

# Let's go!
Dir.foreach('games') do |list|
  next if list =~ /^\./
  f = open("games/#{list}")

  puts "Reading from file #{list}"

  f.readlines.each do |line|
    ip = IPRange.new(line.chomp)
    next unless ip.is_valid_ip_range?  # Skip anything that's not an IP range
    puts "#{ip.split_subnet}"
  end

  f.close
end
