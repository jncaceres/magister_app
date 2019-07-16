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
        oauth_consumer_key = params[:oauth_consumer_key]
        oauth_signature_method = params[:oauth_signature_method]
        oauth_timestamp = params[:oauth_timestamp]
        oauth_nonce = params[:oauth_nonce]

        session[:user_id] = params.require :user_id
        session[:lis_person_name_full] = params.require :lis_person_name_full
        @lis_person_name_full = session[:lis_person_name_full]
        render "/app/views/home/home"
    end

    def launch_error
    end

    private

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end
end
