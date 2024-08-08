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

      # def token_params
      #   #params = options.token_params.merge(options_for("token")).merge(pkce_token_params)
      #   #params
      #   super.tap do |params|
      #     binding.pry
      #     params.delete(:client_id)
      #     # params[:app_key] = options.client_id
      #     # params[:app_secret] = options.client_secret
      #   end
      # end

      # def callback_phase # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      #   error = request.params["error_reason"] || request.params["error"]
      #   if !options.provider_ignores_state && (request.params["state"].to_s.empty? || !secure_compare(request.params["state"], session.delete("omniauth.state")))
      #     fail!(:csrf_detected, CallbackError.new(:csrf_detected, "CSRF detected"))
      #   elsif error
      #     fail!(error, CallbackError.new(request.params["error"], request.params["error_description"] || request.params["error_reason"], request.params["error_uri"]))
      #   else
      #     self.access_token = build_access_token
      #     #binding.pry
      #     self.access_token = access_token.refresh! if access_token.respond_to?(:expired?) && access_token.expired?
      #     super
      #   end
      # rescue ::OAuth2::Error, CallbackError => e
      #   binding.pry
      #   fail!(:invalid_credentials, e)
      # rescue ::Timeout::Error, ::Errno::ETIMEDOUT, ::OAuth2::TimeoutError, ::OAuth2::ConnectionError => e
      #   fail!(:timeout, e)
      # rescue ::SocketError => e
      #   fail!(:failed_to_connect, e)
      # end      

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


      # def build_access_token
      #   verifier = request.params["code"]
      #   params = {}.merge(token_params.to_hash(:symbolize_keys => true))  #:redirect_uri => callback_url
      #   opts = deep_symbolize(options.auth_token_params)
      #   params.merge!('auth_code' => verifier) #, snaky: false)
      #   params_dup = params.dup
      #   params.each_key do |key|
      #     params_dup[key.to_s] = params_dup.delete(key) if key.is_a?(Symbol)
      #   end

      #   puts "\n\n.......strategy....build_access_token....#{params_dup}.......\n"
      #   client.get_token(params_dup, opts)
      # end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
           
    end
  end
end
