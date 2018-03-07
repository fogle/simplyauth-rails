module SimplyAuth
  class PasswordMailer < ApplicationMailer
    def reset_password(reset_password_token)
      @reset_password_token = reset_password_token
      mail(to: reset_password_token.user.email, subject: 'Reset your Password')
    end
  end
end