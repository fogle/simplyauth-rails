module SimplyAuth
  class Session < Model
    attr_accessor :email, :password, :user, :user_pool_id
    validates :email, format: /[^@]+@[^@]+/
    validates :password, length: 6..72
    def attributes
      super.merge(email: email, password: password, id: id)
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
    def destroy
      response = RestClient.delete(
        "https://api.simplyauth.com#{instance_path}",
        accept: :json
      )
    end
  end
end