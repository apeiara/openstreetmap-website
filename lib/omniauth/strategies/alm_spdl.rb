require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class AlmSpdl < OmniAuth::Strategies::OAuth2

      option :name, :alm_spdl

      option :client_options, {
        site: "https://spdl.apeiara.com",
        authorize_url: "/oauth/authorize"
      }

      uid { raw_info['email'] }

      info do
        {
          :email => raw_info['email'],
          :name => [raw_info['given_name'], raw_info['family_name']].join(" ")
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def callback_url
        options[:callback_url] || (full_host + script_name + callback_path)
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v2/employees/me').parsed
      end
    end
  end
end
