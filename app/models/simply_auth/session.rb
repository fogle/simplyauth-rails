module SimplyAuth
  class Session < Model
    attr_accessor :email, :password, :user
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
    def destroy
      response = RestClient.delete(
        "https://api.simplyauth.com#{instance_path}",
        accept: :json
      )
    end
  end
end