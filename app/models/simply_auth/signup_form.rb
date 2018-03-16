module SimplyAuth
  class SignupForm < Model
    attr_accessor :name, :steps, :application_id
    validates :name, :application_id, presence: true

    def attributes
      super.merge(name: name, steps: steps)
    end

    def owner_id
      self.application_id
    end

    def self.owner_class_name
      "Application"
    end

    def destroy
      response = RestClient.delete(
        "https://api.simplyauth.com#{instance_path}",
        accept: :json
      )
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