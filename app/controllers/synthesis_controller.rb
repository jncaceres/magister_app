class SynthesisController < ApplicationController
  before_action :set_breadcrumbs
  before_action :set_homework

  def index
    @homework_name = @homework.name
    puts "<=== AQUI DEBE DESCARGAR EL RESUMEN ===>"
    @answer = "La Respuesta"
  end

  def index_with_edition
    @homework_name = @homework.name
    if request.post?
      @all_text = params["Synthesis Text"]
    else
      @all_text = collect_answers
    end
    @output = sinthesize_text(@all_text)
    @output = sinthesize_text(@output.inner_text)
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
      if alumno.role == "alumno" and alumno.corrector and alumno.answers.find_by_homework_id(@homework.id)
        @my_answer = @corregido.answers.find_by_homework_id(@homework.id)
        @partner_answer = @corrector.answers.find_by_homework_id(@homework.id)
        if @homework.actual_phase == "responder"
          if @my_answer.responder.nil?
            @my_answer.responder = ""
          end
          answer << @my_answer.responder.to_s
          answer << "\n"
        elsif @homework.actual_phase == "argumentar"
          if @partner_answer.argumentar.nil?
            @partner_answer.argumentar = ""
          end
          answer << @partner_answer.argumentar.to_s
          answer << "\n"
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

    def set_homework
      @homework = Homework.find(params[:homework_id])
    end

end
