module SimplyAuth
  class ApiKey < Model
    attr_accessor :name, :id, :secret

    def attributes
      super.merge(name: name, id: id, secret: secret)
    end

    def self.all
      response = RestClient.get(
        "https://api.simplyauth.com#{collection_path}",
        accept: :json
      )
      body = JSON.parse(response.body)
      body.map do |data|
        data = data.deep_transform_keys { |key| key.to_s.underscore }
        new(data)
      end
    end

    def destroy
      RestClient.delete(
        "https://api.simplyauth.com#{instance_path}",
        accept: :json
      )
    end
  end
end