module SimplyAuth
  class User < Model
    attr_accessor :name, :email, :password, :user_pool_id
    validates :name, presence: true
    validates :email, format: /[^@]+@[^@]+/
    validates :password, length: 6..72
    def attributes
      super.merge(name: name, email: email, password: password)
    end

    def self.owner_class_name
      "UserPool"
    end

    def self.all(ids)
      response = RestClient.get(
        "https://api.simplyauth.com#{collection_path(ids)}",
        accept: :json
      )
      body = JSON.parse(response.body)
      body.map do |data|
        data = data.deep_transform_keys { |key| key.to_s.underscore }
        new(data)
      end
    end
  end
end