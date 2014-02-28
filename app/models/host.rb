include SNMP

class Host < ActiveLdap::Base
  ldap_mapping  :dn_attribute => 'cn', 
                :prefix => 'ou=Hosts', 
                :classes => ['ipHost','device']

  def services
    # prNames = oid del nombre de los servicios de snmpd
    # prErrorFlag = sin contiene errores. Si es 0 no contiene errores
    prNames = ObjectId.new("1.3.6.1.4.1.2021.2.1.2")
    prErrorFlag = ObjectId.new("1.3.6.1.4.1.2021.2.1.100")

    prTable_columns = [prNames, prErrorFlag]

    # Consideramos el echo ok
    services_errors = {:echo => 0}

    # Si no responde el ping no hay necesidad de hacer nada.
    if not Net::Ping::TCP.new(self.ipHostNumber).ping?
      services_errors[:echo] = 1
      return services_errors
    end

    # Consideramos que snmp anda salvo que salte una excepcion
    services_errors[:snmp] = 0
    
    begin
      SNMP::Manager.open(:host => self.ipHostNumber) do |manager|
        manager.walk(prTable_columns) do |name, status|
          services_errors[name.value.to_s.to_sym] = status.value.to_i
        end
      end
    rescue
      # No se pudo consultar al snmpd, nada para hacer
      services_errors[:snmp] = 1
    end

    # Retornamos el diccionario con el estado de los servicios 
    services_errors
  end

end