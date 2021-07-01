class User < ApplicationRecord
  has_secure_password
  # soft delete users
  acts_as_paranoid

  # log activities on users
  has_paper_trail

  validates :email,
    presence: true,
    uniqueness: true
end
