class Host < ActiveLdap::Base
  ldap_mapping  :dn_attribute => 'cn', 
                :prefix => 'ou=Hosts', 
                :classes => ['ipHost','device']

  def alive?
    Net::Ping::TCP.new(self.ipHostNumber).ping?
  end

  def ssh?
    begin
      TCPSocket.new(self.ipHostNumber, 'ssh')
    rescue => e
      return false
    end
    return true
  end

  def snmp
    begin
      SNMP::Manager.open(:host => self.ipHostNumber) do |manager|
        response = manager.get(["sysDescr.0"])
        response.each_varbind do |vb|
          mysplit = vb.value.to_s.split
          return "#{mysplit[0]} #{mysplit[2]} #{mysplit[3]}"
        end
      end
    rescue => e
        return e.message
    end
  end

end