module SimplyAuth
  class Application < Model
    validates :name, presence: true
    attr_accessor :name
    def attributes
      super.merge(name: name)
    end

    def signup_forms
      @signup_forms ||= SignupForm.all(id)
    end

    def self.all
      response = RestClient.get(
        "https://api.simplyauth.com#{collection_path}",
        accept: :json
      )
      body = JSON.parse(response.body)[model_name.element.pluralize.camelize(:lower)]
      body.map do |data|
        data = data.deep_transform_keys { |key| key.to_s.underscore }
        new(data).tap{|a| a.persisted = true}
      end
    end
  end
end