class HostActivity < ActiveRecord::Base
  belongs_to :user
  attr_accessible :hostname, :ip, :ports

  # called by request from logged-in user
  def self.update_from_user(user, ip)
    if ip.nil? or ip.blank?
      raise "invalid IP supplied to HostActivity"
    end

    entry = HostActivity.find_by_ip(ip)

    if entry.nil?
      entry = HostActivity.new
      entry.ip = ip
    end

    entry.user = user
    entry.save
  end

  # called by NMAP scanner
  def self.update_from_scan(ip, hostname, ports)
    if ip.nil? or ip.blank?
      raise "invalid IP supplied to HostActivity"
    end

    entry = HostActivity.find_by_ip(ip)

    if entry.nil?
      entry = HostActivity.new
      entry.ip = ip
    end

    entry.hostname = hostname
    entry.ports = ports
    entry.save
  end
end
