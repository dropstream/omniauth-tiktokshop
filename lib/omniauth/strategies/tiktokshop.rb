require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Tiktokshop < OmniAuth::Strategies::OAuth2
      option :name, "tiktokshop_us"

      option :client_options, {
        site: 'https://auth.tiktok-shops.com',
        authorize_url: 'https://auth.tiktok-shops.com/oauth/authorize',
        token_url:  'https://auth.tiktok-shops.com/api/v2/token/get' ,
        token_method: :get,
        extract_access_token: proc do |client, hash|
          hash = hash['data']
          token = hash.delete('access_token') || hash.delete(:access_token)
          token && ::OAuth2::AccessToken.new(client, token, hash)
        end
      }
      
      option :token_params, { grant_type: 'authorized_code' }
      option :provider_ignores_state, true
      

      credentials do
        hash = {}
        hash['token'] = access_token.token
        hash['refresh_token'] = access_token.refresh_token 
        hash['expires_at'] = access_token.params['access_token_expire_in']
        hash['refresh_token_expires_at'] = access_token.params['refresh_token_expire_in']
        hash
      end

      def request_phase
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
      end

      def authorize_params
        super
      end    

      protected
      
      def build_access_token
        params = {
            'app_key' => client.id, 
            'app_secret' => client.secret,
            'auth_code' => request.params['code'],
            'grant_type' => 'authorized_code'
          }
          client.get_token(params, deep_symbolize(options.auth_token_params))
      end


      # NOTE: Use below method incase of above didn't work
      # def build_access_token
      #   verifier = request.params["code"]
      #   params = {}.merge(token_params.to_hash(:symbolize_keys => true))  #:redirect_uri => callback_url
      #   opts = deep_symbolize(options.auth_token_params)
      #   params.merge!('auth_code' => verifier) #, snaky: false)
      #   params_dup = params.dup
      #   params.each_key do |key|
      #     params_dup[key.to_s] = params_dup.delete(key) if key.is_a?(Symbol)
      #   end
      #   client.get_token(params_dup, opts)
      # end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
           
    end
  end
end
