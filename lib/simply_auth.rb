require "simply_auth/engine"
require "simply_auth/version"
require "simply_auth/controller_helpers"
require 'rest-client'
require 'http_signatures'

module SimplyAuth
end

RestClient.add_before_execution_proc do |req, args|
  if req.uri.host == "api.simplyauth.com"
    req["Date"] = Time.now.rfc822
    req["Content-Length"] = args[:payload] ? args[:payload].length.to_s : "0"
    HttpSignatures::Context.new(
      keys: {SimplyAuth::Config.api_key_id => SimplyAuth::Config.api_key_secret},
      algorithm: "hmac-sha256",
      headers: ["Date", "Content-Length"],
    ).signer.sign(req)
  end
end