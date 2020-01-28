class SynthesisController < ApplicationController
  before_action :set_breadcrumbs
  before_action :set_homework

  def index
    @homework_name = @homework.name
    collected_text = collect_answers
    @all_text = parse_text_with_rules(collected_text)
    @answer = sinthesize_text(@all_text)
    @output = sinthesize_text(@answer.inner_text)
  end

  def parse_text_with_rules(old_text)
    new_text = old_text.gsub(URI.regexp, "")
    new_text = old_text.gsub(/(([A-Z]|[a-z])|([0-9]))[.]?[-]?[)][ ]/, "")
    new_text = old_text.gsub(/(([A-Z]|[a-z])|([0-9]))[.]?[-][ ]/, "")
    return new_text
  end

  def index_with_edition
    @homework_name = @homework.name
    if request.post?
      if params["Synthesis Text"].nil?
        saved_values = {"sinthesys": params["Synthesized Text"], "phase": @homework.actual_phase, "homework_id": @homework.id}
        if Sinthesy.create(saved_values)
          flash.alert = "Se ha guardado el resumen correctamente"
          redirect_to homework_path(@homework.id), notice: "Gane"
        else
          flash.alert = "Hubo un error desconocido"
          redirect_to homework_path(@homework.id), notice: "perdí"
        end
      else
        @all_text = params["Synthesis Text"]
      end
    else
      @all_text = collect_answers
    end
    @output = sinthesize_text(@all_text)
    @output = sinthesize_text(@output.inner_text)
    @output = @output.inner_text
  end

  def sinthesize_text(text)
    mechanize = Mechanize.new
    page = mechanize.get('https://www.splitbrain.org/_static/ots/index.php')
    form = page.forms.first
    form['text'] = text
    form.radiobutton_with(:id => "ratio_10").check
    form['lang'] = ['es']
    page = form.submit
    page.search('div').each do |h3|
      h3.text
    end
  end

  def collect_answers
    @homework_name = @homework.name
    id_curso = @homework.course_id
    answer = []
    @course = Course.find_by_id(id_curso)
    @course.users.each do |alumno|
      @corregido = User.find_by_id(alumno.id)
      @corrector = User.find_by_id(alumno.corrector)
      if alumno.role == "alumno" and alumno.answers.find_by_homework_id(@homework.id)
        @my_answer = @corregido.answers.find_by_homework_id(@homework.id)
        if alumno.corrector
          @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
        end
        if @homework.actual_phase == "responder"
          if @my_answer.responder.nil?
            @my_answer.responder = ""
          end
          answer << @my_answer.responder.to_s
          answer << "\n"
        elsif @homework.actual_phase == "argumentar"
          if @course.course_type == "Resumen"
            if @partner_answer
              if @partner_answer.responder.nil?
                @partner_answer.responder = ""
              end
              answer << @partner_answer.responder.to_s
              answer << "\n"
            else
              answer << "No se ha generado ninguna respuesta"
            end
          else
            if @partner_answer
              if @partner_answer.argumentar.nil?
                @partner_answer.argumentar = ""
              end
              answer << @partner_answer.argumentar.to_s
              answer << "\n"
            else
              answer << "No se ha generado ninguna respuesta"
            end
          end
        elsif @homework.actual_phase == "rehacer"
          if @my_answer.rehacer.nil?
            @my_answer.rehacer = ""
          end
          answer << @my_answer.rehacer
          answer << "\n"
        end
        answer << "\n"
      end
    end
    answer = answer.join
  end

  private

    def set_breadcrumbs
      @breadcrumbs = []
    end

    def sinthesys_params
      params.require(:sinthesys).permit(:sinthesys, :phase, :homework_id)
    end

    def set_homework
      @homework = Homework.find(params[:homework_id])
    end

end
