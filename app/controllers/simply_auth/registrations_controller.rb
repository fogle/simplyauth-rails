module SimplyAuth
  class RegistrationsController < ApplicationController
    def new
      @user = SimplyAuth::User.new
    end

    def create
      @user = SimplyAuth::User.new(user_params)
      if @user.save
        # account_name = @user.data.company_name
        # account_name = @user.name if account_name.blank?
        # account = Account.create(name: account_name)
        # @user.data.account_id = account.id
        # @user.save

        @session = SimplyAuth::Session.new(email: user_params[:email], password: user_params[:password])
        @session.save
        session[:simply_auth_session_id] = @session.id
        redirect_to :root
      else
        render :new
      end
    end

    private

    def user_params
      params.require(:simply_auth_user).permit(:name, :email, :password, data: params[:simply_auth_user][:data].keys)
    end
  end
end