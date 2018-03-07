module SimplyAuth
  class PasswordReset < Model
    attr_accessor :password, :reset_password_token_id, :user_pool_id
    def attributes
      super.merge(password: password, reset_password_token_id: reset_password_token_id, user_pool_id: user_pool_id)
    end
    def self.owner_class_name
      "UserPool"
    end
    def owner_id
      user_pool_id
    end
  end
end