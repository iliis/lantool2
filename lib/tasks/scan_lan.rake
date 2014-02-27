require 'nmap/program'
require 'nmap/xml'
require 'socket'

desc "scan local network for machines"
task :scan_lan => :environment do

  puts "gettin local addresses"
  Socket.ip_address_list.each do |intf|
    puts '..................'
    puts intf.ip_address
    puts "loopback?  "+intf.ipv4_loopback?.to_s
    puts "multicast? "+intf.ipv4_loopback?.to_s
    puts "private?   "+intf.ipv4_private?.to_s
  end
  puts '..................'
  addr =  Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast?}
  puts "using: "+addr.ip_address
  puts "canon name: "+addr.canonname unless addr.canonname.nil?

  ip = addr.ip_address.split('.')
  ip.pop # remove last byte
  ip.push '*'
  target = ip.join('.')
  puts "target: " + target
  puts '..................'

  puts "starting NMAP scan"

  scanfile = 'scan_'+rand(1000000).to_s+'.xml'

  Nmap::Program.scan do |nmap|
    #nmap.sudo = true
    
    # host discovery 
    #nmap.ping = true
    #nmap.udp_discovery = true # requires root
    #nmap.icmp_echo_discovery = true # requires root
    nmap.enable_dns = true

    # port scanning
    #nmap.syn_scan = true # requires root
    nmap.connect_scan = true
    #nmap.udp_scan = true # requires root
    #nmap.ack_scan = true # requires root
    #nmap.all_ports = true
    #
    nmap.service_scan = true

    #nmap.verbose = true
    nmap.targets = target
    nmap.normal_timing = true
    nmap.version_all = true

    nmap.xml = scanfile

    puts "NMAP options: #{nmap.options.join(' ')}"
  end

  Nmap::XML.new(scanfile) do |xml|
    xml.each_host do |host|
      puts "found host: #{host.ip.to_s}"

      host.each_hostname do |hostname|
        puts "   > hostname: #{hostname}"
      end

      host.each_open_port do |port|
        puts "   > port: #{port}"
      end

      HostActivity.update_from_scan(host.ip.to_s, host.hostnames.join(', '), host.open_ports.join(', '))
      puts ""
    end
  end

  File.delete(scanfile)
end
