class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :signin_edx
  before_action :set_videos_visible, only: [:index, :show]
  before_action :set_visible_for_admins
  before_action :check_for_bogus_current_course
  skip_before_action :verify_authenticity_token, only: :launch
  after_action :allow_iframe

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:email, :password,
      :password_confirmation, :remember_me, :first_name, :last_name)}
    devise_parameter_sanitizer.permit(:sign_in) {|u| u.permit(:email, :password,
      :password_confirmation, :remember_me, :first_name, :last_name)}
    devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:email, :password,
      :password_confirmation, :remember_me, :first_name, :last_name)}
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      users_path
    else
      super
    end
  end

  def signin_edx
    if params[:lis_person_contact_email_primary]
      user = User.find_by email: params[:lis_person_contact_email_primary]
      sign_in user if user
    end
  end

  def set_color
    if @homework
      if @homework.actual_phase == 'responder'
        @color = 'green'
      elsif @homework.actual_phase == 'argumentar'
        @color = 'yellow'
      elsif @homework.actual_phase == 'rehacer'
        @color = 'magenta'
      elsif @homework.actual_phase == 'evaluar'
        @color = 'brown'
      elsif @homework.actual_phase == 'integrar'
        @color = 'red'
      elsif @homework.actual_phase == 'rehacer_2'
        @color = 'sky'
      end
    else
      @color = 'blue'
    end
  end

  def set_videos_visible
    @videos_visible = true
  end

  def set_visible_for_admins
    if user_signed_in? and !current_user.alumno? then
      @miscursos_visible       = true
      @videos_visible          = true
      @ef_visible              = true
      @reporte_visible         = true
      @actividades_visible     = true
      @Configuraciones_visible = true
    end
  end

  def check_for_bogus_current_course
    if params[:course_id] == '11111' or params[:id] == '11111'
      redirect_to users_path
    end
  end

  def must_be_logged_in
    unless user_signed_in?
      flash.notice = "Para entrar a esta página necesita haber ingresado con sus credenciales"
      redirect_to new_user_session_path
    end
  end
end
