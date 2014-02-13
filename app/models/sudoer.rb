class Sudoer < ActiveLdap::Base
  ldap_mapping  :dn_attribute => 'cn', 
                :prefix => 'ou=SUDOers', 
                :classes => ['sudoRole']
end