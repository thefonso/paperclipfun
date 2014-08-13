class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  has_many :photos

  field :email, type: String
  field :password_digest, type: String
  
  has_secure_password

  validates_uniqueness_of :email
end
