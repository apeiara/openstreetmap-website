require "openid/fetchers"
require "openid/util"
require "omniauth-alm"

CA_BUNDLES = ["/etc/ssl/certs/ca-certificates.crt", "/etc/pki/tls/cert.pem"].freeze

OpenID.fetcher.ca_file = CA_BUNDLES.find { |f| File.exist?(f) }
OpenID::Util.logger = Rails.logger

OmniAuth.config.logger = Rails.logger
OmniAuth.config.failure_raise_out_environments = []

if defined?(MEMCACHE_SERVERS)
  require "openid/store/memcache"

  openid_store = OpenID::Store::Memcache.new(Dalli::Client.new(MEMCACHE_SERVERS, :namespace => "rails"))
else
  require "openid/store/filesystem"

  openid_store = OpenID::Store::Filesystem.new(Rails.root.join("tmp", "openids"))
end

openid_options = { :name => "openid", :store => openid_store }
google_options = { :name => "google", :scope => "email", :access_type => "online" }
facebook_options = { :name => "facebook", :scope => "email" }
windowslive_options = { :name => "windowslive", :scope => "wl.signin,wl.emails" }
github_options = { :name => "github", :scope => "user:email" }
wikipedia_options = { :name => "wikipedia", :client_options => { :site => "https://meta.wikimedia.org" } }

if defined?(GOOGLE_OPENID_REALM)
  google_options[:openid_realm] = GOOGLE_OPENID_REALM
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid, openid_options
  provider :google_oauth2, GOOGLE_AUTH_ID, GOOGLE_AUTH_SECRET, google_options if defined?(GOOGLE_AUTH_ID)
  provider :facebook, FACEBOOK_AUTH_ID, FACEBOOK_AUTH_SECRET, facebook_options if defined?(FACEBOOK_AUTH_ID)
  provider :windowslive, WINDOWSLIVE_AUTH_ID, WINDOWSLIVE_AUTH_SECRET, windowslive_options if defined?(WINDOWSLIVE_AUTH_ID)
  provider :github, GITHUB_AUTH_ID, GITHUB_AUTH_SECRET, github_options if defined?(GITHUB_AUTH_ID)
  provider :mediawiki, WIKIPEDIA_AUTH_ID, WIKIPEDIA_AUTH_SECRET, wikipedia_options if defined?(WIKIPEDIA_AUTH_ID)

  provider :alm_spdl, ALM_SPDL_AUTH_ID, ALM_SPDL_AUTH_SECRET if defined?(ALM_SPDL_AUTH_ID)
  provider :alm_staging, ALM_STAGING_AUTH_ID, ALM_STAGING_AUTH_SECRET if defined?(ALM_STAGING_AUTH_ID)
  provider :alm_uk, ALM_UK_AUTH_ID, ALM_UK_AUTH_SECRET if defined?(ALM_UK_AUTH_ID)
end
