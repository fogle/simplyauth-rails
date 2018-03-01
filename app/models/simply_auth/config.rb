module SimplyAuth::Config
  def self.api_key_id
    ENV["SIMPLY_AUTH_KEY_ID"] || yaml_contents["api_key_id"]
  end

  def self.api_key_secret
    ENV["SIMPLY_AUTH_KEY_SECRET"] || yaml_contents["api_key_secret"]
  end

  def self.user_pool_id
    ENV["SIMPLY_AUTH_USER_POOL_ID"] || yaml_contents["user_pool_id"]
  end

  private
  
  def self.yaml_contents
    @contents ||= read_contents
  end

  def self.read_contents
    yaml = YAML.load(File.read(File.join(Rails.root, "config", "simply_auth.yml")))
    yaml[Rails.env] || {}
  end
end
