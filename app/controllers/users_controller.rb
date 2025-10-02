class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def new
  end

  def create
    @user = User.new(params[:user])    # 実装は終わっていないことに注意!
    if @user.save
      # 保存の成功をここで扱う。
    else
      render 'new', status: :unprocessable_entity
    end
  end
end
