class UsersController < ApplicationController
  before_action :authorize!
  before_action :set_user, except: %i[index]

  before_action :validate_user, except: %i[index]
  before_action :validate_already_archived, only: %i[archive]
  before_action :validate_already_unarchived, only: %i[unarchive]

  def index
    @target_users = get_users(params[:status])

    render jsonapi: @target_users
  end

  def destroy
    # Remove the user
    render json: { error: @target_user.errors.full_messages.join(', ') }, status: :bad_request unless @target_user.destroy

    # Send him email about this changes
    UserMailer.notify_user_deleted(@target_user).deliver_now

    render json: { message: 'user deleted successfully' }, status: :ok
  end

  def archive
    # Archive the user
    render json: { error: @target_user.errors.full_messages.join(', ') }, status: :bad_request unless @target_user.archive!

    # Send him email about this changes
    UserMailer.notify_user_archived(@target_user).deliver_now

    render json: { message: 'user archived successfully' }, status: :ok
  end

  def unarchive
    # Usnarchive the user
    render json: { error: @target_user.errors.full_messages.join(', ') }, status: :bad_request unless @target_user.unarchive!

    # Send him email about this changes
    UserMailer.notify_user_unarchived(@target_user).deliver_now

    render json: { message: 'user unarchived successfully' }, status: :ok
  end

  private

  def set_user
    @target_user = User.find_by(id: params[:id])
  end

  def get_users(status)
    case status
    when 'deleted'
      User.only_deleted
    when 'archived'
      User.archived
    when 'unarchived'
      User.unarchived
    else
      User.all
    end
  end

  def validate_user
    return render json: { error: 'record not found' }, status: :not_found unless @target_user.present?
    render json: { error: 'you cannot delete, archive, or un-archive yourself' },
           status: :not_found if @target_user.id == current_user.id
  end

  def validate_already_archived
    render json: { error: 'user already archived' }, status: :bad_request if @target_user.is_archived?
  end

  def validate_already_unarchived
    render json: { error: 'user already unarchived' }, status: :bad_request unless @target_user.is_archived?
  end
end
