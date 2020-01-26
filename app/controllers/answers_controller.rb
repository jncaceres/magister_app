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
    @user_id = current_user.id

    own_answer = current_user.answers.find_by(homework_id: @homework.id)
    @my_answer = current_user.answers.find_by_homework_id(@homework.id)

    if @homework.responder? or (own_answer and check_answer(own_answer, 'responder')) then
      if @homework.argumentar? or @homework.evaluar?
        @partner_answer = own_answer
        @partner_answer_2 = own_answer
        if Course.find(current_user.current_course_id).course_type == "Resumen"
          @partner_answer.argumentar = @homework.sinthesy.where(phase: "responder").last.sinthesys
        end
        @answer         = @partner_answer

        if @homework.actual_phase == "argumentar"
          #Lista de preguntadas asignadas para argumentar
          assigned = Answer.where(homework_id: @homework.id).where("corrector_id = ? OR corrector_id_2 = ?", current_user.id, current_user.id)
          @partner_answer = nil
          @partner_answer_2 = nil
          @my_argue = nil
          @my_argue_2 = nil

          if assigned.length == 1
            @partner_answer = assigned[0]
            if @partner_answer.corrector_id == current_user.id
              @my_argue = @partner_answer.argumentar
            else
              @my_argue = @partner_answer.argumentar_2
            end

          elsif assigned.length == 2
            @partner_answer = assigned[0]
            @partner_answer_2 = assigned[1]

            if current_user.id == @partner_answer.corrector_id
              @my_argue = @partner_answer.argumentar
            else
              @my_argue = @partner_answer.argumentar_2
            end

            if current_user.id == @partner_answer_2.corrector_id
              @my_argue_2 = @partner_answer_2.argumentar
            else
              @my_argue_2 = @partner_answer_2.argumentar_2
            end
          end
        end

      elsif @homework.rehacer? or @homework.integrar?
        @my_answer      = own_answer
        @partner_answer = @corrector.answers.find_by(homework_id: @homework.id) || @homework.answers.build
        @answer         = @my_answer
      else
        @my_answer      = own_answer
        @answer         = @my_answer
      end
    else
      render 'late' and return
    end

    if @homework.upload
      if @answer.nil?
        redirect_to new_homework_answer_path @homework
      elsif @answer.send(@homework.actual_phase).nil?
        redirect_to edit_homework_answer_path @homework, @answer
      end
    else
      redirect_to users_path
    end
  end

  def show
  end

  def check_answer answer, phase
    return false unless answer
    !(answer.send(phase).blank?) or answer.send("image_#{phase}_1?") or answer.send("image_#{phase}_2?")
  end

  def new
    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Realizar Actividad"]
    @answer = Answer.new

    render 'late' and return unless @homework.responder?
  end

  def edit

    @breadcrumbs = ["Mis Cursos", Course.find(current_user.current_course_id).name, "Realizar Actividad"]
    @corregido = User.find_by_id(current_user.corregido)
    @corrector = User.find_by_id(current_user.corrector)
    @bit_argue = current_user.argument
    @my_answer = current_user.answers.find_by_homework_id(@homework.id)

    if @homework.actual_phase == "evaluar"
      if Course.find(current_user.current_course_id).course_type == "Resumen"
        @partner_answer = @homework.sinthesy.where(phase: "responder").last.sinthesys
        @sintesis = @partner_answer
      else
        @partner_answer = current_user.answers.find_by_homework_id(@homework.id)
      end

    elsif @homework.actual_phase == "argumentar"
      if Course.find(current_user.current_course_id).course_type == "Resumen"
        @partner_answer = @homework.sinthesy.where(phase: "responder").last.sinthesys
        @sintesis = @partner_answer
      else
        if @bit_argue == 1
          #Revisamos si ya tienes preguntas asignadas
          assigned = Answer.where(homework_id: @homework.id).where("corrector_id = ? OR corrector_id_2 = ?", current_user.id, current_user.id).order(:user_id)
          @n_assigned = assigned

          #Si ya tengo preguntas a argumentar asignadas
          if assigned.length > 0
            if assigned.length == 2
              @partner_answer_2 = assigned[1]
            end
            @partner_answer = assigned[0]
          else

            #Si es que no tengo preguntas a argumentar asignadas, las asigno.
            partners_answers = Answer.where("homework_id = ? AND user_id != ? AND corrector_id != ? AND corrector_id_2 != ? AND counter_argue < 2", @homework.id, current_user.id, current_user.id, current_user.id)

            if partners_answers.length > 1
              random_answers = partners_answers.sample(2)
              @partner_answer = random_answers[0]
              @partner_answer_2 = random_answers[1]
              @partner_answer_2.update(counter_argue: @partner_answer_2.counter_argue + 1)

              if @partner_answer_2.counter_argue == 2
                @partner_answer_2.update(corrector_id_2: current_user.id)
              else
                @partner_answer_2.update(corrector_id: current_user.id)
              end

            elsif partners_answers.length == 1
              @partner_answer = partners_answers.sample[0]
            end

            if @partner_answer != nil
              #Actualizamos contador de revision
              @partner_answer.update(counter_argue: @partner_answer.counter_argue + 1)

              if @partner_answer.counter_argue == 2
                @partner_answer.update(corrector_id_2: current_user.id)
              else
                @partner_answer.update(corrector_id: current_user.id)
              end
            end
          end
        end
      end

    elsif @homework.actual_phase == "rehacer" || @homework.actual_phase == "integrar"
      @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
      if Course.find(current_user.current_course_id).course_type == "Resumen"
        @partner_answer.argumentar = @homework.sinthesy.where(phase: "responder").last.sinthesys
      end
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
    if params["commit"] == "Enviar Respuesta" or params["commit"] == "Enviar Argumentación 1" or params["commit"] == "Enviar Argumentación 2"
      redirect_to homework_answers_path(@homework)
    else
      redirect_to edit_homework_answer_path(@homework, @answer)
    end
  end

  def update
    #@my_answer = current_user.answers.find_by_homework_id(@homework.id)
    if @homework.upload
      begin
        user = User.find_by_id(@answer.user_id)
        #corrector = User.find_by_id(user.corrector)
        #@answer.corrector_id = corrector.id
        #@answer.save
      rescue
      end
      respond_to do |format|
        if params["commit"] == "Enviar Argumentación 1"
          partner_id = params["answer"]['partner_answer_id']
          answer_1 = Answer.where("homework_id = ? AND user_id = ? AND corrector_id = ?", @homework.id, partner_id, current_user.id)

          #Si soy el primer corrector
          if answer_1.length == 1
            @partner_answer = answer_1[0]
            @partner_answer.update(argumentar: params["answer"]["argumentar"], phase: params["answer"]["phase"])
            @partner_answer.update(grade_argue_1: params["answer"]['grade_argue_1'])
          else
            answer_2 = Answer.where("homework_id = ? AND user_id = ? AND corrector_id_2 = ?", @homework.id, partner_id, current_user.id)
            @partner_answer = answer_2[0]
            @partner_answer.update(argumentar_2: params["answer"]["argumentar"], phase: params["answer"]["phase"])
            @partner_answer.update(grade_argue_2: params["answer"]['grade_argue_1'])
          end

          if @partner_answer.save
            data = Register.new(button_id:35, user_id:current_user.id)
            data.save
            format.html { redirect_to homework_answers_path(@homework) }
            format.json { render :show, status: :ok, location: @homework }
          else
            format.html { redirect_to edit_homework_answer_path(@homework, @answer) }
            format.json { render json: @homework.errors, status: :unprocessable_entity }
          end

        elsif params["commit"] == "Enviar Argumentación 2"

          partner_id = params["answer"]['partner_answer_id']
          answer_1 = Answer.where("homework_id = ? AND user_id = ? AND corrector_id = ?", @homework.id, partner_id, current_user.id)

          #Si soy el primer corrector
          if answer_1.length == 1
            @partner_answer_2 = answer_1[0]
            @partner_answer_2.update(argumentar: params["answer"]["argumentar"], phase: params["answer"]["phase"])
            @partner_answer_2.update(grade_argue_1: params["answer"]['grade_argue_1'])
          else
            answer_2 = Answer.where("homework_id = ? AND user_id = ? AND corrector_id_2 = ?", @homework.id, partner_id, current_user.id)
            @partner_answer_2 = answer_2[0]
            @partner_answer_2.update(argumentar_2: params["answer"]["argumentar"], phase: params["answer"]["phase"])
            @partner_answer_2.update(grade_argue_2: params["answer"]['grade_argue_1'])
          end

          if @answer.save
            data = Register.new(button_id:35, user_id:current_user.id)
            data.save
            format.html { redirect_to homework_answers_path(@homework) }
            format.json { render :show, status: :ok, location: @homework }
          else
            format.html { redirect_to edit_homework_answer_path(@homework, @answer) }
            format.json { render json: @homework.errors, status: :unprocessable_entity }
          end

        else
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

  def pdf_crear(lista, lista_num_alum, letra)
    lista.each do |ans|
      #filename = "pdfs/" + @homework.id.to_s + "_" + current_user.first_name + "_" + current_user.last_name + c.to_s + ".pdf"
      begin
        filename = "pdfs/" + lista_num_alum[letra]
        filename = filename.force_encoding("UTF-8")
        Prawn::Document.generate (filename) do |pdf|
          ans.each do |element|
            pdf.text element
          end
        end
      rescue Exception => error
        Prawn::Document.generate (filename) do |pdf|
          ans.each do |element|
            pdf.text "todo_mal_aqui:_"
          end
        end
      end
      #send_file filename
      letra += 1
    end
  end

  def generate_pdf
    regex = /[^\u1F600-\u1F6FF\s]/i
    nombre_tarea = @homework.name
    lista = []
    lista_num_alum = []
    id_curso = @homework.course_id
    @curso = Course.find_by_id(id_curso)
    @curso.users.each do |alumno|
      @corregido = User.find_by_id(alumno.id)
      @corrector = User.find_by_id(alumno.corrector)
      if alumno.role == "alumno" and alumno.corrector and alumno.answers.find_by_homework_id(@homework.id)# and @corrector.answers.find_by_homework_id(@homework.id)
        if params['names'] == 'true'
            nombre_usuario = @corregido.first_name + " " + @corregido.last_name
            nombre_corrector = @corrector.first_name + " " + @corrector.last_name
        else
            nombre_usuario = ""
            nombre_corrector = ""
        end
        if @homework.actual_phase == "argumentar" || @homework.actual_phase == "evaluar"
          @my_answer = @corregido.answers.find_by_homework_id(@homework.id)
          @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
          if @my_answer.evaluar.nil?
            @my_answer.evaluar = ""
          end
          if @my_answer.argumentar.nil?
            @my_answer.argumentar = ""
          end
          answer = []
          mail = @corregido.email.split("@")
          # answer << "Numero de alumno: " + mail[0]
          answer << "Nombre usuario: " + nombre_usuario
          answer << "Nombre corrector: " + nombre_corrector
          answer << "Responder:"
          answer << @partner_answer.responder.to_s
          answer << "\nArgumentar:"
          answer << @my_answer.argumentar.to_s
          #answer << "\nRehacer:"
          #answer << @partner_answer.rehacer
          #answer << "\nEvaluar:"
          #answer << @my_answer.evaluar
          lista << answer
          lista_num_alum << mail[0] + ".pdf"
        elsif @homework.actual_phase == "rehacer" || @homework.actual_phase == "integrar" ||  @homework.actual_phase == "responder"
          @my_answer = @corregido.answers.find_by_homework_id(@homework.id)
    	    if @my_answer.responder.nil?
            @my_answer.responder = ""
    	    end
    	    if @my_answer.rehacer.nil?
            @my_answer.rehacer = ""
          end
          #@my_answer = Answer.first
          @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
          #@partner_answer = Answer.first
          answer = []
    	    mail = @corregido.email.split("@")
          # answer << "Numero de alumno: " + mail[0]
	        answer << "Nombre usuario: " + nombre_usuario
          answer << "Nombre corrector: " + nombre_corrector
          answer << "Responder:"
	        responder1 = @my_answer.responder.to_s
	        responder2 = responder1.each_char.select { |char| char.bytesize < 3 }.join  #responder1.gsub(regex, '')  #.gsub(/[^0-9A-Za-z]/, ' ')
          answer << responder2  #responder1.gsub(regex, '')
          if @homework.actual_phase != "responder"
            answer << "\nArgumentar:"
  	        if @partner_answer != nil
  	          if @partner_answer.argumentar == nil
  		          answer << ""
  	          else
  	      	    argumentar1 = @partner_answer.argumentar.to_s
  	      	    argumentar2 = argumentar1.each_char.select { |char| char.bytesize < 3 }.join
                answer << argumentar2 # argumentar1.gsub(regex, '')  #.gsub(/[^0-9A-Za-z]/, ' ')
  	          end
  	        else
  	          answer << ""
  	        end
            answer << "\nRehacer:"
  	        if @my_answer != nil
              if @my_answer.rehacer == nil
                answer << ""
              else
                respuesta = @my_answer.rehacer.to_s
                respuesta2 = respuesta.each_char.select { |char| char.bytesize < 3 }.join
                answer << respuesta2 # respuesta.gsub(regex, '')
              end
            else
              answer << ""
            end
          end
          # respuesta = @my_answer.rehacer.to_s
	        # respuesta2 = respuesta.each_char.select { |char| char.bytesize < 4 }.join
          # answer << respuesta2 #respuesta.gsub(regex, '') #.gsub(/[^0-9A-Za-z]/, ' ')
          #answer << "\nEvaluar:"
          #answer << @partner_answer.evaluar
          #answer << "\nIntegrar:"
          #answer << @my_answer.integrar
          lista << answer
	        nombre = mail[0] + ".pdf"
          lista_num_alum << nombre
        end
      end
    end
    a = 0
    b = lista.length/3
    c = lista.length*2/3
    lista1 = lista[0..lista.length/3]
    lista2 = lista[lista.length/3..lista.length*2/3]
    lista3 = lista[lista.length*2/3..lista.length]
    th1 = Thread.new {pdf_crear(lista1, lista_num_alum, a)}

    th2 = Thread.new {pdf_crear(lista2, lista_num_alum, b)}

    th3 = Thread.new {pdf_crear(lista3, lista_num_alum, c)}
    th1.join()
    th2.join()
    th3.join()
    folder = "/home/patricio/Documentos/Magister/magister_app/pdfs"
    input_filenames = lista_num_alum
    zipfile_name = "/home/patricio/Documentos/Magister/magister_app/" + nombre_tarea + ".zip"
    Zip.continue_on_exists_proc = true
    Zip.unicode_names = true
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
      # Two arguments:
      # - The name of the file as it will appear in the archive
      # - The original file, including the path to find it
        zipfile.add(filename, File.join(folder, filename))
      end
      #zipfile.get_output_stream("myFile") { |f| f.write "myFile contains just this" }
    end
    zipfile = File.read(zipfile_name)
    send_data(zipfile, :type => "application/zip", :filename => nombre_tarea + ".zip")
    File.delete(zipfile_name)
    #redirect_to :back
 end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_homework
      @homework = Homework.find(params[:homework_id])
      #homework_id
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
       :image_evaluar_1, :image_evaluar_2, :image_integrar_1, :image_integrar_2,
       :corrector_id, :argumentar_2, :grade_argue_1, :grade_argue_2, :grade_eval_1,
       :grade_eval_2)
    end
end
