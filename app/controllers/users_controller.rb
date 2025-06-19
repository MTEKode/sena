class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    throw StandardError.new("Affiliate key is not valid") if @user.affiliate_key.present? && !valid_affiliate_key
    throw

    if @user.save
      redirect_to root_path, notice: 'User was successfully created.'
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name, :affiliate_key, :terms_accepted, :subscription_type)
  end

  def valid_affiliate_key
    true
  end

end
