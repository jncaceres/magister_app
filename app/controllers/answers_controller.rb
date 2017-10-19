class AnswersController < ApplicationController
  before_action :set_homework
  before_action :set_answer, only: [:edit, :destroy, :show, :update]
  before_action :set_actividades_visible, only: :new
  before_action :set_breadcrumbs
  before_filter :authenticate_user!
  before_action :set_color
  #skip_before_filter :verify_authenticity_token, only:[:update, :destroy]

  def index
    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Realizar Actividad"]
    @corregido = User.find_by_id(current_user.corregido)
    @corrector = User.find_by_id(current_user.corrector)
    if @homework.actual_phase == "argumentar" || @homework.actual_phase == "evaluar"
      @my_answer = @corregido.answers.find_by_homework_id(@homework.id)
      @partner_answer = current_user.answers.find_by_homework_id(@homework.id)
    elsif @homework.actual_phase == "rehacer" || @homework.actual_phase == "integrar"
      @my_answer = current_user.answers.find_by_homework_id(@homework.id)
      @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
    else
      @my_answer = current_user.answers.find_by_homework_id(@homework.id)
    end
    @answer = current_user.answers.find_by_homework_id(@homework.id)
    if @homework.upload == true && @answer == nil
      redirect_to new_homework_answer_path(@homework)
    elsif @homework.upload == true && @answer != nil
      if @homework.actual_phase == "argumentar" && @answer.argumentar == nil
        redirect_to edit_homework_answer_path(@homework, @answer)
      elsif @homework.actual_phase == "rehacer" && @answer.rehacer == nil
        redirect_to edit_homework_answer_path(@homework, @answer)
      elsif @homework.actual_phase == "evaluar" && @answer.evaluar == nil
        redirect_to edit_homework_answer_path(@homework, @answer)
      elsif @homework.actual_phase == "integrar" && @answer.integrar == nil
        redirect_to edit_homework_answer_path(@homework, @answer)
      end
    elsif @homework.current == false
      redirect_to users_path
    end
  end

  def show
  end

  def new
    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Realizar Actividad"]
    @answer = Answer.new
  end

  def edit
    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Realizar Actividad"]
    @corregido = User.find_by_id(current_user.corregido)
    @corrector = User.find_by_id(current_user.corrector)
    if @homework.actual_phase == "argumentar" || @homework.actual_phase == "evaluar"
      @my_answer = @corregido.answers.find_by_homework_id(@homework.id)
      @partner_answer = current_user.answers.find_by_homework_id(@homework.id)
    elsif @homework.actual_phase == "rehacer" || @homework.actual_phase == "integrar"
      @my_answer = current_user.answers.find_by_homework_id(@homework.id)
      @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
    else
      @my_answer = current_user.answers.find_by_homework_id(@homework.id)
    end
  end

  def create
    data = Register.new(button_id:35, user_id:current_user.id)
    data.save
    if @homework.upload
      @answer = Answer.new(answer_params)
      current_user.answers << @answer
      @homework.answers << @answer
      @answer.homework = @homework
    end
    if params["commit"] == "Enviar Respuesta"
      redirect_to homework_answers_path(@homework)
    else
      redirect_to edit_homework_answer_path(@homework, @answer)
    end
  end

  def update
    if @homework.upload
      begin
        user = User.find_by_id(@answer.user_id)
        corrector = User.find_by_id(user.corrector)
        @answer.corrector_id = corrector.id
        @answer.save
      rescue
      end
      respond_to do |format|
        @answer.update(answer_params)
        if @answer.save
          if params["commit"] == "Enviar Respuesta"
            data = Register.new(button_id:35, user_id:current_user.id)
            data.save
            format.html { redirect_to homework_answers_path(@homework)}
            format.json { render :show, status: :ok, location: @homework }
          else
            if @answer.phase.downcase != @homework.actual_phase
              format.html { redirect_to homework_answers_path(@homework)}
              format.json { render :show, status: :ok, location: @homework }
            else
              #format.js
            end
          end
        else
          format.html { redirect_to edit_homework_answer_path(@homework, @answer) }
          format.json { render json: @homework.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to homework_answers_path(@homework)
    end
  end

  def favorite
    @answer = Answer.find_by homework_id: params[:homework_id], user_id: params[:user_id]
    @answer.update(favorite: params[:favorite])

    redirect_to studentanswer_path(params[:homework_id], homework_id: params[:homework_id], user_id: params[:user_id])
  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to homework_questions_path(@homework) }
      format.json { head :no_content }
    end
  end

  def generate_pdf
    @corregido = User.find_by_id(current_user.corregido)
    @corrector = User.find_by_id(current_user.corrector)
    begin
      if @homework.actual_phase == "argumentar" || @homework.actual_phase == "evaluar"
        @my_answer = @corregido.answers.find_by_homework_id(@homework.id)
        @partner_answer = current_user.answers.find_by_homework_id(@homework.id)
        answer = []
        answer << "Responder:"
        answer << @partner_answer.responder
        answer << "\nArgumentar:"
        answer << @my_answer.argumentar
        answer << "\nRehacer:"
        answer << @partner_answer.rehacer
        answer << "\nEvaluar:"
        answer << @my_answer.evaluar
      elsif @homework.actual_phase == "rehacer" || @homework.actual_phase == "integrar" ||  @homework.actual_phase == "responder"
        @my_answer = current_user.answers.find_by_homework_id(@homework.id)
        @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
        answer = []
        answer << "Responder:"
        answer << @my_answer.responder
        answer << "\nArgumentar:"
        answer << @partner_answer.argumentar
        answer << "\nRehacer:"
        answer << @my_answer.rehacer
        answer << "\nEvaluar:"
        answer << @partner_answer.evaluar
        answer << "\nIntegrar:"
        answer << @my_answer.integrar
      end
    rescue
    end

    Prawn::Document.generate (@homework.id.to_s + "_" + current_user.first_name + "_" + current_user.last_name + ".pdf") do |pdf|
      answer.each do |element|
        pdf.text element
       end
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_homework
      @homework = Homework.find(params[:homework_id])
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:phase, :upload, :responder, :argumentar,
       :rehacer, :evaluar, :integrar, :image_responder_1, :image_responder_2,
       :image_argumentar_1, :image_argumentar_2, :image_rehacer_1,  :image_rehacer_2,
       :image_evaluar_1, :image_evaluar_2, :image_integrar_1, :image_integrar_2, :corrector_id)
    end

end
