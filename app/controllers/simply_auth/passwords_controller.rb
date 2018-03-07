module SimplyAuth
  class PasswordsController < ApplicationController
    def new
      @reset_password_token = SimplyAuth::ResetPasswordToken.new(permit_password_params)
    end

    def create
      @reset_password_token = SimplyAuth::ResetPasswordToken.new(password_params)
      if @reset_password_token.save
        PasswordMailer.reset_password(@reset_password_token).deliver_now
        flash[:notice] = "Please check your email for password reset instructions."
        redirect_to new_session_path
      else
        render :new
      end
    end

    def edit
      @reset_password_token = SimplyAuth::ResetPasswordToken.find(params[:token])
      @password_reset = SimplyAuth::PasswordReset.new(reset_password_token_id: params[:token])
    end

    def update
      @password_reset = SimplyAuth::PasswordReset.new(password_reset_params)
      @reset_password_token = SimplyAuth::ResetPasswordToken.find(@password_reset.reset_password_token_id)
      if @password_reset.save
        redirect_to new_session_path
      else
        render :edit
      end
    end

    private

    def password_params
      params.require(:reset_password_token).permit(:email)
    end

    def password_reset_params
      params.require(:password_reset).permit(:reset_password_token_id, :password)
    end

    def permit_password_params
      params.permit(:reset_password_token => :email)[:reset_password_token]
    end
  end
end