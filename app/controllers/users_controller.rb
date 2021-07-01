class UsersController < ApplicationController
  before_action :authorize!
  before_action :set_user, except: %i[index]
  before_action :validate_user, except: %i[index]

  def index
    render jsonapi: User.all
  end

  def destroy
    # Remove the user
    render json: { error: @user.errors.full_messages.join(', ')}, status: :bad_request unless @user.destroy

    # Send him email about this changes
    UserMailer.notify_user_deleted(@user).deliver_now

    render json: {message: 'user deleted successfully'}, status: :ok
  end

  def archive

  end

  def unarchive

  end

  private

  def set_user
    @user = User.find_by(id: param[:id])
  end

  def validate_user
    render json: { error: 'record not found' }, status: :not_found unless @user.present?
    render json: { error: 'you cannot delete, archive, or un-archive yourself' },
           status: :not_found if @user.id == current_user.id
  end
end
