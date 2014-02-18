class Host < ActiveLdap::Base
  ldap_mapping  :dn_attribute => 'cn', 
                :prefix => 'ou=Hosts', 
                :classes => ['ipHost','device']
end