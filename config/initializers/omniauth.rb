Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '317467998278508', 'edb0f470addae80c6ca67b31d3b5b58f', {client_options: {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}, :scope => 'publish_stream, offline_access, email, create_event, rsvp_event, xmpp_login'}
end