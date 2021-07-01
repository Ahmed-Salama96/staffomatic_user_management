class UserMailer < ApplicationMailer
  def notify_user_deleted(user)
    @user = user
    mail(to: user.email, subject: 'You have been deleted!')
  end

  def notify_user_archived(user)
    @user = user
    mail(to: user.email, subject: 'You have been archived')
  end

  def notify_user_unarchived(user)
    @user = user
    mail(to: user.email, subject: 'You have been unarchived')
  end
end
