class LtiController < ApplicationController
    before_action :set_breadcrumbs
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
        session[:lis_person_contact_email_primary] = params.require :lis_person_contact_email_primary
        if session[:lis_person_contact_email_primary] in User.all.map(&:email)
          user = User.find_by_email(session[:lis_person_contact_email_primary])
          sign_in(:user, user)
          redirect_to users_path
        end
        #elsif
         # render "lti/launch_error", status: 401
        #end
        #if user_signed_in?
          #redirect_to users_path
        #elsif
          #render "home/home"
        #end
    end

    def launch_error
    end

    private

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end

    def set_breadcrumbs
      @breadcrumbs = []
    end

  end