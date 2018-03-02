module SimplyAuth
  class RegistrationsController < ApplicationController
    def new
      @user = SimplyAuth::User.new
    end

    def after_registration(user); end

    def create
      @user = SimplyAuth::User.new(user_params)
      if @user.save
        after_registration(@user)

        @session = SimplyAuth::Session.new(email: user_params[:email], password: user_params[:password])
        @session.save
        session[:simply_auth_session_id] = @session.id
        redirect_to "/"
      else
        render :new
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, data: params[:user][:data].try(:keys))
    end
  end
end