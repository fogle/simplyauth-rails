module SimplyAuth
  class UserPool < Model
    validates :name, presence: true
    attr_accessor :name
    def attributes
      super.merge(name: name)
    end

    def self.instance_path(ids = [])
      if ids.empty?
        super([SimplyAuth::Config.user_pool_id])
      else
        super(ids)
      end
    end

    def self.all
      response = RestClient.get(
        "https://api.simplyauth.com#{collection_path}",
        accept: :json
      )
      body = JSON.parse(response.body)[model_name.element.pluralize.camelize(:lower)]
      body.map do |data|
        data = data.deep_transform_keys { |key| key.to_s.underscore }
        new(data)
      end
    end

    def users
      User.all(id)
    end
  end
end