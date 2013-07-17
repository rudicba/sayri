class Group < ActiveLdap::Base
  ldap_mapping  :dn_attribute => 'cn',
                :prefix => 'ou=Groups',
                :classes => ['PosixGroup']
                
  has_many      :members, :class_name => 'User', :wrap => 'memberUid', 
                :primary_key => 'uid'

  validates     :cn, :gidnumber, :presence => true
  validates     :gidnumber, :numericality => { :only_integer => true }

  # Search groups by a CN
  def self.id_search(search)
    search = search.to_s
    Group.find(:all, :attribute => 'cn', :value => "#{search}*")
  end
end