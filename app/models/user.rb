class User < ActiveLdap::Base
  ldap_mapping  :dn_attribute => 'uid', 
                :prefix => 'ou=People', 
                :classes => ['inetOrgPerson', 'posixAccount']
                
  belongs_to    :groups, :class_name => 'Group', :many => 'memberUid'

  validates     :cn, :sn, :homedirectory, :uid, :presence => true
  validates     :uidnumber, :gidnumber, :presence => true, 
                :numericality => { :only_integer => true }

  # Search a user by a UID
  def self.id_search(search)
    search = search.to_s
    User.find(:all, :attribute => 'uid', :value => "#{search}*")
  end

  # Return an activeldap user if login and password are OK
  def self.try_to_login(login, password)
    login = login.to_s
    password = password.to_s

    return nil if login.empty? || password.empty?
    user = find_by_login(login)
    if user
      return nil unless user.check_password?(password)
    end
    user
  end

  # Searches for a user with exactly the same uid
  # Return user if there or nil
  def self.find_by_login(login)
    if login.present?
      login = login.to_s
      if User.exists?(login)
        user = User.find(login)
      end
    end
    user
  end

  # Check that the password is correct
  # Return true if password Ok, or nil
  def check_password?(password)
    self.bind(password)
    true
    rescue ActiveLdap::AuthenticationError
      false
  end
end
