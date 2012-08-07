require 'set'
require 'carmen'
require 'eu'

# The Expert model provides access to the experts data and several methods
# for manipulation.
#
# Database scheme:
#
# - *id* integer
# - *user_id* integer
# - *name* string
# - *prename* string
# - *gender* string
# - *birthname* string
# - *birthday* string
# - *birthplace* string
# - *citizenship* string
# - *degree* string
# - *former_collaboration* boolean
# - *fee* string
# - *company* string
# - *created_at* datetime
# - *updated_at* datetime
class Expert < ActiveRecord::Base
  attr_accessible(:name, :prename, :gender, :birthname, :birthday, :fee,
                  :birthplace, :citizenship, :degree, :former_collaboration,
                  :company)

  has_one    :contact,   autosave: true, dependent: :destroy, as: :contactable
  has_one    :comment,   autosave: true, dependent: :destroy, as: :commentable
  has_many   :addresses, autosave: true, dependent: :destroy, as: :addressable
  has_many   :cvs,       autosave: true, dependent: :destroy
  belongs_to :user

  # Set of vailable genders.
  GENDERS = Set.new([:female, :male])

  # Returns a valid gender symbol using the GENDERS list.
  #
  #   Expert.gender('female')
  #   #=> :female
  #
  # If no valid symbol is found, the first symbol in GENDERS is returned.
  def self.gender(gender)
    g = gender.try(:to_sym)
    GENDERS.include?(g) ? g : GENDERS.first
  end

  # Initializes the contact on access, if not already initalized.
  def contact
    super || self.contact = Contact.new
  end

  # Initializes the comment on access, if not already initialized.
  def comment
    super || self.comment = Comment.new
  end

  # Returns the experts gender.
  def gender
    Expert.gender(super)
  end

  # Sets the experts gender. If the given gender is invalid, a default value
  # is assigned.
  def gender=(gender)
    super(Expert.gender(gender).to_s)
  end

  # Returns true if expert is an EU citizen, else false.
  def eu?
    Eu.eu?(citizenship)
  end

  # Returns the localized country name.
  def human_citizenship
    Carmen::Country.coded(citizenship).try(:name)
  end

  # Returns a string containing name and prename.
  def full_name
    "#{prename} #{name}"
  end

  # Returns a string containing degree, prename and name.
  #
  #   expert.full_name_with_degree
  #   #=> "Dr. Alan Turing"
  def full_name_with_degree
    "#{degree} #{prename} #{name}"
  end

  # Returns the experts age or nil if the birthday is unknown.
  #
  #   expert.age
  #   #=> 43
  def age
    return nil unless birthday

    now = Time.now.utc.to_date
    age = now.year - birthday.year

    if now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)
      age - 1
    else
      age
    end
  end
end
