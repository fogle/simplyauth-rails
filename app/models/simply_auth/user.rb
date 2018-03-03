module SimplyAuth
  class User < Model
    attr_accessor :name, :email, :password, :user_pool_id
    validates :email, format: /[^@]+@[^@]+/
    validates :password, length: 6..72, if: :password_or_new_record?

    def password_or_new_record?
      password || !persisted?
    end

    def attributes
      super.merge(name: name, email: email, password: password)
    end

    def owner_id
      self.user_pool_id
    end

    def self.owner_class_name
      "UserPool"
    end

    def self.all(ids)
      response = RestClient.get(
        "https://api.simplyauth.com#{collection_path(ids)}",
        accept: :json
      )
      body = JSON.parse(response.body)[model_name.element.pluralize.camelize(:lower)]
      body.map do |data|
        data = data.deep_transform_keys { |key| key.to_s.underscore }
        new(data)
      end
    end
  end
end