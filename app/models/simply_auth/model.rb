require 'rest-client'

module SimplyAuth
  class Model
    include ActiveModel::Model
    include ActiveModel::Dirty
    include ActiveModel::Conversion
    attr_accessor :id

    def initialize(*args)
      super(*args)
      @persisted = false
    end

    def persisted?
      @persisted
    end

    def persisted=(val)
      @persisted = val
    end

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
      {id: id, data: data.to_h}
    end

    def save
      if valid?
        attributes = self.attributes.deep_transform_keys{|k| k.to_s.camelize(:lower)}
        # Rails.logger.error([
        #   persisted? ? :patch : :post,
        #   "https://api.simplyauth.com#{persisted? ? instance_path : collection_path}",
        #   {model_name.element.camelize(:lower) => attributes}.to_json,
        #   {accept: :json,
        #   content_type: :json}
        # ].inspect)
        response = RestClient.send(
          persisted? ? :patch : :post,
          "https://api.simplyauth.com#{persisted? ? instance_path : collection_path}",
          {model_name.element.camelize(:lower) => attributes}.to_json,
          accept: :json,
          content_type: :json
        )
        body = JSON.parse(response.body)[model_name.element.camelize(:lower)]
        body = body.deep_transform_keys { |key| key.to_s.underscore } if body
        self.attributes = self.class.new.attributes.merge(body || {})
        changes_applied
        self.persisted = true
        true
      else
        false
      end
    rescue RestClient::UnprocessableEntity => e
      errors = JSON.parse(e.http_body)["errors"]
      errors.each do |k, v|
        v.each do |err|
          self.errors.add(k, err)
        end
      end
      false
    end

    def self.owner_class
      @owner_class_set ||= false
      return @owner_class if @owner_class_set
      return nil unless self.owner_class_name
      @owner_class = "SimplyAuth::#{self.owner_class_name}".constantize
      @owner_class_set = true
      @owner_class
    end

    def self.path_component
      model_name.element.pluralize.dasherize
    end

    def self.owner_class_name
      nil
    end

    def owner_id
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

    def collection_path
      if owner_id
        self.class.collection_path(owner_id)
      else
        self.class.collection_path
      end
    end

    def instance_path
      if owner_id
        self.class.instance_path([owner_id, id])
      else
        self.class.instance_path(id)
      end
    end

    def self.instance_path(ids = [])
      ids = [ids].flatten
      if self.owner_class
        "#{self.owner_class.instance_path(ids.first(ids.length - 1))}/#{path_component}/#{ERB::Util.url_encode(ids.last)}"
      else
        "/#{path_component}/#{ERB::Util.url_encode(ids.last)}"
      end
    end

    def self.find(ids)
      response = RestClient.get(
        "https://api.simplyauth.com#{instance_path(ids)}",
        accept: :json
      )
      body = JSON.parse(response.body)[model_name.element.camelize(:lower)]
      body = body.deep_transform_keys { |key| key.to_s.underscore }
      new(body).tap do |r|
        r.persisted = true
      end
    end

    def self.create(attributes={})
      r = new(attributes)
      r.save()
      r
    end
  end
end