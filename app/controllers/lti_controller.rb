class LtiController < ApplicationController
    after_action :allow_iframe
    def launch
        if not Rails.configuration.lti_settings[params[:oauth_consumer_key]]
            render "lti/launch_error", status: 401
            return
        end 
        condicion_1 = params[:lti_message_type] == "basic-lti-launch-request"
        condicion_2 = params[:lti_version] == "LTI-1p0"
        condicion_3 = params[:resource_link_id]
        
        require 'oauth/request_proxy/rack_request'
        @provider = IMS::LTI::ToolProvider.new(
          params[:oauth_consumer_key],
          Rails.configuration.lti_settings[params[:oauth_consumer_key]],
          params
        )
        render_plain: params.sort
        return

        if not @provider.valid_request?(request)
          # the request wasn't validated
          render "lti/launch_error", status: 401
          return
        end

        session[:user_id] = params.require :user_id
        session[:lis_person_name_full] = params.require :lis_person_name_full
        @lis_person_name_full = session[:lis_person_name_full]
        redirect_to root_path
    end

    def launch_error
    end

    private

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end
end
