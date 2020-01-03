class LtiController < ApplicationController
    after_action :allow_iframe
    before_action :set_breadcrumbs, only: [:launch_error]
    def launch
        if not Rails.configuration.lti_settings[params[:oauth_consumer_key]]
            redirect_to lti_launch_error_path
            return
        end 
        condicion_1 = params[:lti_message_type] == "basic-lti-launch-request"
        condicion_2 = params[:lti_version] == "LTI-1p0"
        condicion_3 = params[:resource_link_id]
        oauth_consumer_key = params[:oauth_consumer_key]
        oauth_signature_method = params[:oauth_signature_method]
        oauth_timestamp = params[:oauth_timestamp]
        oauth_nonce = params[:oauth_nonce]

        if condicion_1 and condicion_2 and condicion_3
          session[:user_id] = params.require :user_id
          session[:lis_person_contact_email_primary] = params.require :lis_person_contact_email_primary
          if User.all.map(&:email).include? session[:lis_person_contact_email_primary]
            user = User.find_by_email(session[:lis_person_contact_email_primary])
            sign_in(:user, user)
            redirect_to users_path
          elsif
            redirect_to lti_launch_error_path
          end
        elsif 
          redirect_to lti_launch_error_path
            return
        end
    end

    def launch_error
      sign_out current_user
    end

    private

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end
    
    def set_breadcrumbs
      @breadcrumbs = []
    end
  end