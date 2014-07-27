class User
  include Mongoid::Document

  has_many :games

  field :email, type: String
  field :username, type: String
  field :password, type: String
  field :score, type: Integer, default: 0

  index({ email: 1 }, { unique: true, name: "email_unique_index" })
  index({ username: 1 }, { unique: true, name: "username_unique_index" })
end