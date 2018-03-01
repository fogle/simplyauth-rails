module SimplyAuth
  class Model
    include ActiveModel::Model
    include ActiveModel::Dirty
    include ActiveModel::Conversion
    attr_accessor :id

    def data
      @data ||= OpenStruct.new
    end

    def data=(val)
      @data = OpenStruct.new(val)
    end
   
    def attributes=(hash)
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def attributes
      {id: id, data: data}
    end

    def save
      if valid?
        response = RestClient.send(
          persisted? ? :patch : :post,
          "https://api.simplyauth.com#{instance_path}",
          attributes.to_json,
          accept: :json,
          content_type: :json
        )
        body = JSON.parse(response.body)
        body = body.deep_transform_keys { |key| key.to_s.underscore }
        self.attributes = body
        changes_applied
        true
      else
        false
      end
    end

    def self.owner_class
      return @owner_class if @owner_class_set
      @owner_class = "SimplyAuth::#{self.owner_class_name}".constantize if self.owner_class_name
      @owner_class_set = true
      @owner_class
    end

    def self.path_component
      model_name.element.pluralize.dasherize
    end

    def self.owner_class_name
      nil
    end

    def self.collection_path(owner_ids = [])
      ids = [ids].flatten
      if self.owner_class
        "#{self.owner_class.instance_path(owner_ids)}/#{path_component}"
      else
        "/#{path_component}"
      end
    end

    def instance_path
      self.class.instance_path(id)
    end

    def self.instance_path(ids = [])
      ids = [ids].flatten
      if self.owner_class
        "#{self.owner_class.instance_path(ids.first(ids.length - 1))}/#{path_component}/#{ids.last}"
      else
        "/#{path_component}/#{ids.last}"
      end
    end

    def self.find(ids)
      response = RestClient.get(
        "https://api.simplyauth.com#{instance_path(ids)}",
        accept: :json
      )
      body = JSON.parse(response.body)
      body = body.deep_transform_keys { |key| key.to_s.underscore }
      new(body)
    end
  end
end