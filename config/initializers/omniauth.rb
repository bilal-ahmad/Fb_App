if Rails.env.production?
  APP_ID = "260685093987581"
  APP_SECRET = "e151eec9f06f59b97fad93c072258497"
elsif Rails.env.development?
  APP_ID = "317467998278508"
  APP_SECRET = "edb0f470addae80c6ca67b31d3b5b58f"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, APP_ID, APP_SECRET, {client_options: {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}, :scope => 'publish_stream, offline_access, email, create_event, rsvp_event, xmpp_login'}
end