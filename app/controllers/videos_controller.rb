class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :set_breadcrumbs
  before_action :set_course
  before_action :set_videos_visible
  before_action :set_miscursos_visible
  before_action :set_ef_visible
  before_action :set_reporte_visible
  before_action :set_actividades_visible
  before_action :set_configuraciones_visible

  # GET /videos
  # GET /videos.json
  def index
    @breadcrumbs = ["Mis Cursos", @course.name, "Videos"]
    @units = Video.includes(tree: :content).where(course_id: @course.id).order(:unit, :name).group_by(&:unit)
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @breadcrumbs = ["Mis Cursos", @course.name, "Videos", @video.name]
    @counter = $redis.incr("video:#{@video.id}")
  end

  # GET /videos/new
  def new
    @url = course_videos_path
    @breadcrumbs = ["Mis Cursos", @course.name.name, "Videos", "Agregar Video"]
    @video = Video.new
    @trees = @course.trees.includes(:content).joins(:content).order('contents.text')
  end

  # GET /videos/1/edit
  def edit
    @url = course_video_path
    @breadcrumbs = ["Mis Cursos", @course.name.name, "Videos", "Editar Video"]
    @trees = @course.trees.includes(:content).joins(:content).order('contents.text')
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)
    respond_to do |format|
      if @video.save
        format.html { redirect_to course_videos_path(@video.id), notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to course_videos_path(@video.id), notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to course_videos_path, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.includes(tree: :content).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:url, :name, :course_id, :final_url,:tree_id,:unit)
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

    def set_course
      @course = Course.find_by_id(params[:course_id] || current_user.current_course_id)
    end
end
