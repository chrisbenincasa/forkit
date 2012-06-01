class Authuser < User
  has_many :authorizations

  validates :name, :email, :presence => :true
end
