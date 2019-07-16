class LtiController < ApplicationController
    def launch
        if not Rails.configuration.lti_settings[params[:oauth_consumer_key]]
            render "lti/launch_error", status: 401
            return
        end 

        require 'oauth/request_proxy/action_controller_request'
        @provider = IMS::LTI::ToolProvider.new(
          params[:oauth_consumer_key],
          Rails.configuration.lti_settings[params[:oauth_consumer_key]],
          params
        )

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
end
