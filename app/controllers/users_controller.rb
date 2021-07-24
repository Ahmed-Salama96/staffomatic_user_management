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
    render jsonapi_errors: @target_user.errors, status: :unprocessable_entity unless @target_user.destroy

    UserMailer.notify_user_deleted(@target_user).deliver_now

    render json: { message: 'user deleted successfully' }, status: :ok
  end

  def archive
    render jsonapi_errors: @target_user.errors, status: :unprocessable_entity unless @target_user.archive!

    # Send him email about this changes
    UserMailer.notify_user_archived(@target_user).deliver_now

    render json: { message: 'user archived successfully' }, status: :ok
  end

  def unarchive
    render jsonapi_errors: @target_user.errors, status: :unprocessable_entity unless @target_user.unarchive!

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
    return render jsonapi_errors: 'record not found', status: :not_found unless @target_user.present?
    render jsonapi_errors: 'you cannot delete, archive, or un-archive yourself' ,
           status: :unprocessable_entity if @target_user.id == current_user.id
  end

  def validate_already_archived
    render jsonapi_errors: 'user already archived', status: :unprocessable_entity if @target_user.is_archived?
  end

  def validate_already_unarchived
    render jsonapi_errors: 'user already unarchived', status: :unprocessable_entity unless @target_user.is_archived?
  end
end
