# The Privilege model is used to hold User permissions.
#
# Database Scheme:
#
# - *user_id* integer
# - *amdin* boolean
# - *experts* boolean
# - *partners* boolean
# - *references* boolean
#
# This is not very fancy.
class Privilege < ActiveRecord::Base
  belongs_to :user

  # A list of all sections.
  SECTIONS = [:experts, :partners, :references]

  # Checks for access privileges for a specified section.
  #
  #   if privilege.access?(:experts)
  #     write_some_experts_data(data)
  #   end
  #
  # Returns true if access is granted, else false.
  def access?(section)
    admin? || (respond_to?(section) && send(section))
  end

  # Returns the privileges hash.
  #
  #   privilege.privileges
  #   #=> { experts: true, partners: false, references: true }
  #
  # If the admin attribute is _true_, the hash contains the single key
  # _admin_ with the value _true_.
  def privileges
    if admin?
      { admin: true }
    else
      Hash[SECTIONS.map { |s| [s, send(s)] }]
    end
  end

  # Sets the privileges. It takes a hash of sections and their corresponding
  # access values.
  #
  #   privilege.privileges = { experts: true, references: false }
  #   privilege.privileges
  #   #=> { experts: true, partners: false, references: false }
  #
  # If the :admin is set to true, all sections will be set to true.
  def privileges=(privileges)
    self.admin = privileges[:admin]

    SECTIONS.each do |section|
      self[section] = admin? || privileges[section]
    end
  end

  # Checks permissions to write some employees data. Employee is a subresource
  # of Partner, so the user needs the permissions to write partners data.
  def employees
    partners?
  end
end
