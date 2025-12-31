class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # （1）への対応

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new', status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # （3）への対応
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_content
    elsif @user.update(user_params)                     # （4）への対応
      @user.forget
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)   
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit', status: :unprocessable_content      # （2）への対応
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルタ

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      Rails.logger.error "[valid_user] start"

      Rails.logger.error "[valid_user] params[:id]=#{params[:id]}"
      Rails.logger.error "[valid_user] user present? #{@user.present?}"

      if @user
        Rails.logger.error "[valid_user] activated? #{@user.activated?}"
        Rails.logger.error "[valid_user] reset_digest present? #{@user.reset_digest.present?}"
        Rails.logger.error "[valid_user] authenticated? #{@user.authenticated?(:reset, params[:id])}"
      end

      ok = @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      Rails.logger.error "[valid_user] result=#{ok}"

      redirect_to root_url unless ok
    end
    # 期限切れかどうかを確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end

