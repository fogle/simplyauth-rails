module SimplyAuth
  class ResetPasswordToken < Model
    attr_accessor :email, :user_pool_id, :expires_at, :created_at, :user
    validates :email, format: /[^@]+@[^@]+/
    def attributes
      super.merge(email: email)
    end
    def user
      User.new(@user)
    end

    def self.owner_class_name
      "UserPool"
    end
    def owner_id
      user_pool_id
    end
  end
end