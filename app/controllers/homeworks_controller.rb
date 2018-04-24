class HomeworksController < ApplicationController
  before_action :must_be_logged_in
  before_action :set_homework, only: [:show, :edit, :update, :close_activity, :destroy, :change_phase, :asistencia, :full_answers]
  before_action :set_course
  before_action :set_unavailable
  skip_before_action :set_unavailable, only: [:show, :change_phase, :answers]
  before_action :set_miscursos_visible, only: :index
  before_action :set_ef_visible, only: :index
  before_action :set_actividades_visible, only: [:index, :show, :asistencia, :edit, :new, :answers]
  before_action :set_reporte_visible , only: [:index]
  before_action :set_configuraciones_visible, only: :index
  before_action :set_breadcrumbs
  before_action :set_color
  before_action :set_videos_visible, only: :index

  def index
    redirect_to courses_path unless @course
    if params["format"]
      if params["format"]["volver"]
        data = Register.new(button_id:16, user_id:current_user.id)
        data.save
      end
    end
    if current_user.role?
      @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Actividades Colaborativas"]
      for i in @course.homeworks
        i.current = false
        i.upload = false
#        i.actual_phase = "responder"
        i.save
      end
      @homeworks = @course.homeworks.sort_by{|e| e[:created_at]}
    else
      @homework = @course.homeworks.where(current: true)[0]
      if @homework
        answers = current_user.answers.find_by_homework_id([@homework.id])
        if @homework.upload == false
          redirect_to homework_answers_path(@homework)
        elsif @homework.upload == true && answers == nil
          redirect_to new_homework_answer_path(@homework)
        elsif @homework.upload == true && answers != nil
          if @homework.actual_phase == "argumentar" && answers.argumentar == nil
            redirect_to edit_homework_answer_path(@homework, answers)
          elsif @homework.actual_phase == "rehacer" && answers.rehacer == nil
            redirect_to edit_homework_answer_path(@homework, answers)
          elsif @homework.actual_phase == "evaluar" && answers.evaluar == nil
            redirect_to edit_homework_answer_path(@homework, answers)
          elsif @homework.actual_phase == "integrar" && answers.integrar == nil
            redirect_to edit_homework_answer_path(@homework, answers)
          else
            redirect_to homework_answers_path(@homework)
          end
        end
      end
    end
  end

  def close_activity
    # @homework
    #   .course
    #   .users
    #   .update_all(partner_id: nil, corrector: nil, corregido: nil)
    
    redirect_to homeworks_path
  end

  def change_phase
    if params["phase"] != nil and have_answered(@homework)
      if params[:next]
        if @homework.actual_phase == "responder"
          asistentes
          generate_partner
          @homework.actual_phase = "argumentar"
          data = Register.new(button_id:17, user_id:current_user.id)
        elsif @homework.actual_phase == "argumentar"
          @homework.actual_phase = "rehacer"
          data = Register.new(button_id:18, user_id:current_user.id)
        elsif @homework.actual_phase == "rehacer"
          @homework.actual_phase = "evaluar"
          data = Register.new(button_id:19, user_id:current_user.id)
        elsif @homework.actual_phase == "evaluar"
          @homework.actual_phase = "integrar"
          data = Register.new(button_id:20, user_id:current_user.id)
        end
        @homework.upload = true
      elsif params[:previous]
        if @homework.actual_phase == "argumentar"
          @homework.actual_phase = "responder"
          data = Register.new(button_id:22, user_id:current_user.id)
        elsif @homework.actual_phase == "rehacer"
          @homework.actual_phase = "argumentar"
          data = Register.new(button_id:23, user_id:current_user.id)
        elsif @homework.actual_phase == "evaluar"
          @homework.actual_phase = "rehacer"
          data = Register.new(button_id:24, user_id:current_user.id)
        elsif @homework.actual_phase == "integrar"
          @homework.actual_phase = "evaluar"
          data = Register.new(button_id:25, user_id:current_user.id)
        end
        @homework.upload = true
      elsif params[:discussion]
        data = Register.new(button_id: Homework.actual_phases[@homework.actual_phase] + 27, user_id: current_user.id)
        @homework.upload = false
      end
      data.save
      @homework.save
    end
    redirect_to homework_path(@homework.id)
  end

  def show
    if current_user.role?
      @homework.upload = true
      current_user.last_homework = @homework.id
      current_user.last_asistencia = DateTime.now
      current_user.save
      @homework.current = true
      @homework.save
    end
    asistentes
    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Actividades Colaborativas", "Realizar Actividad"]
    @homework.save
    if current_user.role?
      if @homework.actual_phase == "responder"
        data = Register.new(button_id:14, user_id:current_user.id)
      	data.save
	      @etapa = "Responder"
        @siguiente = "Argumentar"
      elsif @homework.actual_phase == "argumentar"
        @etapa = "Argumentar"
        @siguiente = "Rehacer"
      elsif @homework.actual_phase == "rehacer"
        @etapa = "Rehacer"
        @siguiente = "Evaluar"
      elsif @homework.actual_phase == "evaluar"
        @etapa = "Evaluar"
        @siguiente = "Integrar"
      elsif @homework.actual_phase == "integrar"
        @etapa = "Integrar"
      end
      if !@homework.upload
        @etapa = "Discusión"
      end
    else
      redirect_to homework_answers_path(@homework)
    end
  end

  def asistentes
    @users   = []
    @current = 0
    @total   = 0

    @students = Course.find(current_user.current_course_id).users.where(role:0)
    @answers  = Answer.includes(:user).where(homework_id: @homework.id).has_answered(@homework.actual_phase)
    @users    = User.where(id: @answers.map(&:user_id))
    @total    = @students.count
    @current  = @users.count
  end

  def new
    data = Register.new(button_id:9, user_id:current_user.id)
    data.save
    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Actividades Colaborativas", "Crear Actividad"]
    @homework = Homework.new
  end

  def edit
    data = Register.new(button_id:12, user_id:current_user.id)
    data.save
    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Actividades Colaborativas", "Editar Actividad"]
  end

  def answers
    @etapa = ""

    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Actividades Colaborativas", "Realizar Actividad", "Respuesta Alumno"]
    @homework = Homework.where(id:params["homework_id"].to_i)[0]

    @etapa = @homework.actual_phase.capitalize

    @user = User.find_by_id(params["user_id"])
    @corregido = User.find_by_id(@user.corregido)
    @corrector = User.find_by_id(@user.corrector)
    if @homework.actual_phase == "argumentar" || @homework.actual_phase == "evaluar"
      @my_answer = @corregido.answers.find_by_homework_id(@homework.id)
      @partner_answer = @user.answers.find_by_homework_id(@homework.id)
      @answer = @partner_answer
    elsif @homework.actual_phase == "rehacer" || @homework.actual_phase == "integrar"
      @my_answer = @user.answers.find_by_homework_id(@homework.id)
      @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
      @answer = @my_answer
    else
      @my_answer = @user.answers.find_by_homework_id(@homework.id)
      @partner_answer = @corregido.answers.find_by_homework_id(@homework.id)
      @answer = @my_answer
    end
    data = Register.new(button_id:33, user_id:current_user.id)
    data.save
    render 'studentanswer'
  end

  def create
    if params["tag_in_index"]
      data = Register.new(button_id:36, user_id:current_user.id)
      data.save
      @homework = Homework.where(id:params["actualizar"]["homework"])[0]
      answers = current_user.answers.find_by_homework_id([@homework.id])
      if params["tag_in_index"] == "Editar Respuesta" && @homework.upload
        redirect_to edit_homework_answer_path(@homework, answers)
      else
        redirect_to homework_answers_path(@homework)
      end
    else
      @homework = Homework.new(homework_params)
      @course.homeworks << @homework
      data = Register.new(button_id:10, user_id:current_user.id)
      data.save
      respond_to do |format|
        if @homework.save
          format.html { redirect_to homeworks_path, notice: 'La actividad ha sido creada.' }
          format.json { render :show, status: :created, location: @homework }
        else
          format.html { render :new }
          format.json { render json: @homework.errors, status: :unprocessable_entity }
        end
      end
      @homework.course_id = current_user.current_course_id
      @homework.save
    end
  end

  def update
    data = Register.new(button_id:13, user_id:current_user.id)
    data.save
    respond_to do |format|
      if @homework.update(homework_params)
        format.html { redirect_to homeworks_path } # REDIRECT TO INDEX
        format.json { render :index, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @homework.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    data = Register.new(button_id:11, user_id:current_user.id)
    data.save
    @homework.destroy
    respond_to do |format|
      format.html { redirect_to homeworks_url, notice: 'La actividad fue removida.' }
      format.json { head :no_content }
    end
  end

  def generate_partner
    users = @users.students.to_a

    if !@homework.partners
      i = rand(users.length)
      cabeza = users[i]
      anterior = users[i]
      users.delete_at(i)
      while users.length > 1
        i = rand(users.length)
        actual = users[i]
        actual.corrector = anterior.id
        anterior.corregido = actual.id
        anterior.save
        anterior = actual
        users.delete_at(i)
      end
      actual = users[0]
      actual.corrector = anterior.id
      anterior.corregido = actual.id
      cabeza.corrector = actual.id
      actual.corregido = cabeza.id
      anterior.save
      actual.save
      cabeza.save
      users.delete_at(0)
      @homework.upload = true
      @homework.current = true
      @homework.partners = true
      @homework.save
    end
  end

  def full_answers
    @students = @course.users.where(role:0)
    render 'full-answers'
  end

  private
    def set_homework
      @homework = Homework.includes(:answers).find(params[:id])
    end

    def set_course
      @course = Course.find_by_id(current_user.current_course_id)
    end

    def set_unavailable
      if current_user.role?
        for i in @course.homeworks
          i.upload = false
          i.save
        end
      end
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

    def set_breadcrumbs
      @breadcrumbs = []
    end

    def image_up
      if Homework.find(params[:id]).image?
        @h_image = true
      end
    end

    def have_answered(homework)
      phase = homework.actual_phase

      if homework.answers.select do |a| a.send(phase + "?") or a.send("image_#{phase}_1?") end.count > 2
        return true
      else
        flash.alert = "Se necesita que respondan al menos 3 alumnos para hacer el sorteo."
        
        return false
      end
    end

    def homework_params
      params.require(:homework).permit(:name, :content, :actual_phase, :upload, :courses, :image, :current)
    end
end
