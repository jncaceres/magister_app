class LtiController < ApplicationController
    before_action :set_breadcrumbs
    after_action :allow_iframe
    before_action :set_miscursos_visible, only: :index
    before_action :set_actividades_visible, only: :show
    before_action :set_videos_visible, only: :show
    before_action :set_users
    before_action :set_courses
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
        if user_signed_in?
          render "users/index"
        elsif
          render "home/home"
        end
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

    def admin_only
      unless current_user.profesor?
        redirect_to :back
      end
    end
  
    def secure_params
      params.require(:user).permit(:role)
    end
  
    def set_asistente
      @asistente = User.find(params[:id])
    end
  
    def set_users
      @users = User.all
    end
  
    def set_courses
      @courses = current_user.courses
    end
  
    def set_miscursos_visible
      @miscursos_visible = true
    end
  
    def set_ef_visible
      @ef_visible = true
    end
  
    def set_reporte_visible
      @reporte_visible = true
    end
  
    def set_actividades_visible
      @actividades_visible = true
    end
  
    def set_configuraciones_visible
      @Configuraciones_visible = true
    end
  
end
