
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '260685093987581', 'e151eec9f06f59b97fad93c072258497', {client_options: {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}, :scope => 'publish_stream, offline_access, email, manage_pages, create_event, rsvp_event, xmpp_login'}
end