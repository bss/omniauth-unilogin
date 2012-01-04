require 'omniauth'
require 'digest/md5'
require 'base64'
require 'cgi'

module OmniAuth
  module Strategies
    class Unilogin
      include OmniAuth::Strategy
      
      args [:emu_id, :emu_secretkey]
      
      option :emu_id, nil
      option :emu_secretkey, nil
      
      option :emu_login_path, 'https://sso.emu.dk/unilogin/login.cgi'
      option :emu_login_timeout_secs, 300
      
      option :name, 'unilogin'

      def other_phase
        if on_path?(failure_path)
          fail!('invalid_credentials')
        else
          call_app!
        end
      end

      def failure_path
        options[:failure_path] || "#{path_prefix}/failure"
      end

      def request_phase
        auth = Digest::MD5.hexdigest(callback_url+options.emu_secretkey)
        auth_url = options.emu_login_path+"?id="+options.emu_id+"&path="+CGI::escape(Base64.strict_encode64(callback_url))+"&auth="+auth
        redirect auth_url
      end
      
      def callback_phase
        fail!("auth_error.hash") if invalidHash?(request.params)
        fail!("auth_error.expired") if expired?(request.params)
        super
      end
      
      def invalidHash?(params)
    		Digest::MD5.hexdigest(params["timestamp"]+options.emu_secretkey+params["user"]) != params["auth"]
      end
      
      def expired?(params)
        (Time.now.utc.strftime("%Y%m%d%H%M%S").to_i - params["timestamp"].to_i) > options.emu_login_timeout_secs
      end
      
      def callback_url
        full_host + script_name + callback_path
      end

      uid{ raw_info['user'] }
      extra{ {:raw_info => raw_info} }

      info do
        {
          :username => raw_info['user']
        }
      end

      def raw_info
        {"user" => request.params["user"]}
      end
      
    end
  end
end