class CoursesController < ApplicationController


  before_action :set_course, only: [:asistencia, :students, :show, :edit, :update, :destroy, :archive, :eval_form, :reportes, :students_report, :st_report]
  before_action :set_miscursos_visible, only: [:show, :edit, :new, :eval_form, :reportes, :students_report, :st_report]
  before_action :set_ef_visible, only: [:show, :edit, :eval_form, :reportes]
  before_action :set_reporte_visible, only: [:show, :edit, :eval_form, :reportes, :students_report, :st_report]
  before_action :set_actividades_visible, only: [:show, :edit, :eval_form, :reportes]
  before_action :set_configuraciones_visible, only: [:show, :edit, :eval_form, :reportes]
  before_action :set_breadcrumbs
  before_action :set_videos_visible, only: [:index, :show, :eval_form, :reportes]


  def index
    @course = Course.find(params[:id])
    @courses = Course.all
  end

  def archived
    @courses = Course.where(id: CourseUser.where(user_id: current_user.id, archived: true).pluck(:course_id))
  end

  def show
    @breadcrumbs = ["Mis Cursos", @course.name]
    @courses = Course.all
    current_user.current_course_id = @course.id
    current_user.save
    if params['format']
      if params['format']["Ingresar"]
        data = Register.new(button_id:4, user_id:current_user.id)
      elsif params['format']["Guardar Cambios"]
        data = Register.new(button_id:7, user_id:current_user.id)
      end
      data.save
    end
    if !current_user.role?
      redirect_to homeworks_path
    end
  end

  def new
    data = Register.new(button_id:2, user_id:current_user.id)
    data.save
    @breadcrumbs = ["Mis Cursos", "Crear Curso"]
    @course = Course.new
  end

  def edit
    if params["tag"]
      if params["tag"] == "configuraciones"
        data = Register.new(button_id:5, user_id:current_user.id)
        data.save
      end
    end
    @breadcrumbs = ["Mis Cursos", @course.name, "Configuraciones"]
    @course = Course.find(params[:id])
    @users = @course.users
    if params.index("Remover")
      user = User.find_by_id(params.index("Remover"))
      user.courses.destroy(@course)
      data = Register.new(button_id:6, user_id:current_user.id)
      data.save
    else
      if params["roles"] != nil
        params["roles"].each do |p|
          user = User.find_by_id(p[0])
          user.role = p[1]["role"]
          user.save
        end
        redirect_to course_path(current_user.current_course_id, "Guardar Cambios")
      end
    end
  end

  def agregate
    course = Course.all.where(course_code: params["new_code_course"]["course_code"])[0]
    if course
      if !current_user.courses.find_by_id(course.id)
        current_user.courses << course
        current_user.save
      end
    end
    redirect_to users_path
  end

  def create
    data = Register.new(button_id:3, user_id:current_user.id)
    data.save
    @course = Course.new(course_params)
    respond_to do |format|
      if @course.save
        @course.course_code = @course.description.to_s + current_user.id.to_s + @course.id.to_s
        if @course.save
          format.html { redirect_to users_path}
          format.json { render :show, status: :created, location: @course }
        else
          format.html { render :new }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
    
    if user = User.where(id: 0).first then
      user.courses << @course
      user.save
    end

    current_user.courses << @course
    current_user.save
  end

  def archive
    CourseUser
      .where(user_id: current_user.id)
      .where(course_id: @course.id)
      .update_all(archived: params[:_method] == "post")

    redirect_to root_path
  end

  def eval_form
    @breadcrumbs = ["Mis Cursos", @course.name, "Evaluación Formativa"]
    @trees = @course.trees.includes(:content).joins(:content).order('contents.text').all
  end

  def reportes
    # @breadcrumbs = ["Mis Cursos", @course.name, "Reportes"]
    # render "reports"
    redirect_to course_reports_path(@course)
  end

  def students_report
    @breadcrumbs = ["Mis Cursos", @course.name, "Reportes", "Reportes de Alumnos"]
    @users_sc = Hash.new

    @course.users.each do |user|
      if user.role == "alumno"

        content_sc = 0
        interpretation_sc = 0
        analysis_sc = 0
        evaluation_sc = 0
        inference_sc = 0
        explanation_sc = 0
        selfregulation_sc = 0
        content_n = 0
        interpretation_n = 0
        analysis_n = 0
        evaluation_n = 0
        inference_n = 0
        explanation_n = 0
        selfregulation_n = 0

        @course.trees.each do |tree|
          performance = tree.user_tree_performances.find_by(:user_id => user.id)
          puts "performanceeeeeeeeeeeeeee de los usariooooooooooooooooooooooo"
          puts performance.inspect
          if performance
            if performance.content_sc
            content_sc = content_sc + (performance.content_sc / performance.content_n)
            content_n = content_n + 1
            end
            if performance.interpretation_sc
            interpretation_sc = interpretation_sc + (performance.interpretation_sc / performance.interpretation_n)
            interpretation_n = interpretation_n + 1
            end
            if performance.analysis_sc
            analysis_sc = analysis_sc + (performance.analysis_sc / performance.analysis_n)
            analysis_n = analysis_n + 1
            end
            if performance.evaluation_sc
            evaluation_sc = evaluation_sc + (performance.evaluation_sc / performance.evaluation_n)
            evaluation_n = evaluation_n + 1
            end
            if performance.inference_sc
            inference_sc = inference_sc + (performance.inference_sc / performance.inference_n)
            inference_n = inference_n + 1
            end
            if performance.explanation_sc
            explanation_sc = explanation_sc + (performance.explanation_sc / performance.explanation_n)
            explanation_n = explanation_n + 1
            end
            if performance.selfregulation_sc
            selfregulation_sc = selfregulation_sc + (performance.selfregulation_sc / performance.selfregulation_n)
            selfregulation_n = selfregulation_n + 1
            end
          end
        end
        if content_n != 0
          content_sc = (content_sc / content_n).round(2)
        else
          content_sc = nil
        end
        if interpretation_n != 0
          interpretation_sc = (interpretation_sc / interpretation_n).round(2)
        else
          interpretation_sc = nil
        end
        if analysis_n != 0
          analysis_sc = (analysis_sc / analysis_n).round(2)
        else
          analysis_sc = nil
        end
        if evaluation_n != 0
          evaluation_sc = (evaluation_sc / evaluation_n).round(2)
        else
          evaluation_sc = nil
        end
        if inference_n != 0
          inference_sc = (inference_sc / inference_n).round(2)
        else
          inference_sc = nil
        end
          if explanation_n != 0
          explanation_sc = (explanation_sc / explanation_n).round(2)
        else
          explanation_sc = nil
        end
        if selfregulation_n != 0
          selfregulation_sc = (selfregulation_sc / selfregulation_n).round(2)
        else
          selfregulation_sc = nil
        end

        @users_sc[user.id] = {:name => user.last_name + ", " +  user.first_name, :content_sc => content_sc, :interpretation_sc => interpretation_sc,
          :analysis_sc => analysis_sc, :evaluation_sc => evaluation_sc, :inference_sc => inference_sc, :explanation_sc => explanation_sc, :selfregulation_sc => selfregulation_sc}

         puts "un user_score es------------------------------------"
         puts @users_sc[user.id].inspect
         puts " "

     end
    end

    render 'users_report'

  end

  def st_report
    @student = User.find(params[:st_id])
    @breadcrumbs = ["Mis Cursos", @course.name, "Reportes", "Reportes de Alumnos", @student.first_name + " " + @student.last_name]
    @student = User.find(params[:st_id])
    @performances = Hash.new

    content_n = 0
    interpretation_n = 0
    analysis_n = 0
    evaluation_n = 0
    inference_n = 0
    explanation_n = 0
    selfregulation_n = 0
    content_m = 0
    interpretation_m = 0
    analysis_m = 0
    evaluation_m = 0
    inference_m = 0
    explanation_m = 0
    selfregulation_m = 0

    @course.trees.each do |tree|
      performance = UserTreePerformance.find_by(:user_id => @student.id, :tree_id => tree.id)
      content_sc = nil
      interpretation_sc = nil
      analysis_sc = nil
      evaluation_sc = nil
      inference_sc = nil
      explanation_sc = nil
      selfregulation_sc = nil

      puts "holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0"
      puts content_m
      puts content_n

      if !performance.nil?
          if !performance.content_sc.nil?
            puts "holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
            puts @content_m
            puts performance.content_sc
            puts performance.content_n
            content_sc = (performance.content_sc / performance.content_n).round(2)
            content_m = content_m + (performance.content_sc / performance.content_n)
            content_n = content_n + 1
          end
          if performance.interpretation_sc
            interpretation_sc =  (performance.interpretation_sc / performance.interpretation_n).round(2)
            interpretation_m = interpretation_m + (performance.interpretation_sc / performance.interpretation_n)
            interpretation_n = interpretation_n + 1
          end
          if performance.analysis_sc
            analysis_sc = (performance.analysis_sc / performance.analysis_n).round(2)
            analysis_m = analysis_m + (performance.analysis_sc / performance.analysis_n)
            analysis_n = analysis_n + 1
          end
          if performance.evaluation_sc
            evaluation_sc = (performance.evaluation_sc / performance.evaluation_n).round(2)
            evaluation_m = evaluation_m + (performance.evaluation_sc / performance.evaluation_n)
            evaluation_n = evaluation_n + 1
          end
          if performance.inference_sc
            inference_sc = (performance.inference_sc / performance.inference_n).round(2)
            inference_m = inference_m + (performance.inference_sc / performance.inference_n)
            inference_n = inference_n + 1
          end
          if performance.explanation_sc
            explanation_sc = (performance.explanation_sc / performance.explanation_n).round(2)
            explanation_m = explanation_m + (performance.explanation_sc / performance.explanation_n)
            explanation_n = explanation_n + 1
          end
          if performance.selfregulation_sc
            selfregulation_sc = (performance.selfregulation_sc / performance.selfregulation_n).round(2)
            selfregulation_m = selfregulation_m + (performance.selfregulation_sc / performance.selfregulation_n)
            selfregulation_n = selfregulation_n + 1
          end
          the_tree = Tree.find(tree.id)
          @performances[tree.id] = {:content => the_tree.content.text, :content_sc => content_sc, :interpretation_sc => interpretation_sc, :analysis_sc => analysis_sc, :evaluation_sc => evaluation_sc, :inference_sc => inference_sc, :explanation_sc => explanation_sc, :selfregulation_sc => selfregulation_sc}


        end

      end


      if content_n != 0
        content_m = content_m / content_n
      else
        content_m = nil
      end
      if interpretation_n != 0
        interpretation_m = interpretation_m / interpretation_n
      else
        interpretation_m = nil
      end
      if analysis_n != 0
        analysis_m = (analysis_m / analysis_n).round(2)
      else
        analysis_m = nil
      end
      if evaluation_n != 0
        evaluation_m = (evaluation_m / evaluation_n).round(2)
      else
        evaluation_m = nil
      end
      if inference_n != 0
        inference_m = (inference_m / inference_n).round(2)
      else
        inference_m = nil
      end
      if explanation_n != 0
        explanation_m = (explanation_m / explanation_n).round(2)
      else
        explanation_m = nil
      end
      if selfregulation_n != 0
        selfregulation_m = (selfregulation_m / selfregulation_n).round(2)
      else
        selfregulation_m = nil
      end
      @avarage = {:content_av => content_m, :interpretation_av => interpretation_m,
      :analysis_av => analysis_m, :evaluation_av => evaluation_m, :inference_av => inference_m, :explanation_av => explanation_m, :selfregulation_av => selfregulation_m}



    render 'st_report'
  end

  def students
    @users = @course.users
  end

  def update
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :description, :button)
    end

    def set_breadcrumbs
      @breadcrumbs = []
    end
end
