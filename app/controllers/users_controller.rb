class UsersController < ApplicationController
  before_action :authorize!
  before_action :set_user, except: %i[index]
  before_action :validate_user, except: %i[index]

  def index
    render jsonapi: User.all
  end

  def destroy
    user_id = @user.id
    user_email = @user.email

    # Remove the user
    render json: { error: @user.errors.full_messages.join(', ')}, status: :bad_request unless @user.destroy

    # log changes
    # Send him email about this changes
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
