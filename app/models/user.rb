class User < ApplicationRecord
  has_secure_password
  # soft delete users
  acts_as_paranoid

  # log activities on users
  has_paper_trail

  validates :email,
    presence: true,
    uniqueness: true

  def archive!
    self.update(is_archived: true)
  end

  def unarchive!
    self.update(is_archived: false)
  end
end
