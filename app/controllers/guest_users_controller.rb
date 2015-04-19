class GuestUsersController < ApplicationController

  include Devise::Controllers::Rememberable

  before_action :authenticate_user!, except: :create
  before_action :require_guest, except: :create

  def create
    if user_signed_in?
      redirect_to root_url, alert: "You must be logged out to create a new guest user"
    else
      username = "guest_#{rand(1000000)}"
      5.times do
        if User.where(username: username).count == 0
          break
        end
        username = "guest_#{rand(1000000)}"
      end
      if User.where(username: username).count > 0
        redirect_to root_url, alert: "Cannot generate guest account. Please try again later."
      else
        password = Devise.friendly_token
        user = User.create!(username: username, email: "#{username}@example.com", 
                            password: password, password_confirmation: password,
                            guest: true)
        sign_in(:user, user)
        remember_me(user)
        DeleteGuestAccountJob.set(wait_until: 3.days.from_now).perform_later(user)
        redirect_to root_url, notice: "You are currently logged in as a guest account. This account will be deleted in 3 days unless you convert it to a regular account."
      end
    end
  end

  def edit
    @user = current_user.dup
    @user.email = ""
    @user.username = ""
  end

  def update
    if current_user.update_attributes(user_params.merge guest: false)
      redirect_to login_url, notice: "Successfully converted to regular user. Please sign in to continue."
    else
      @user = current_user
      render :edit
    end
  end

  private

  def require_guest
    unless current_user.guest
      redirect_to root_url, alert: "Access denied"
    end
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
