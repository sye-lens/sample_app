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
      rid = request.request_id

      user_present = @user.present?
      activated    = @user&.activated?
      auth         = @user ? @user.authenticated?(:reset, params[:id]) : false
      ok           = user_present && activated && auth

      Rails.logger.error(
        "[valid_user #{rid}] method=#{request.request_method} path=#{request.fullpath} " \
        "email_param=#{params[:email]} uid=#{@user&.id} uemail=#{@user&.email} " \
        "present=#{user_present} activated=#{activated} auth=#{auth} ok=#{ok}"
      )

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

