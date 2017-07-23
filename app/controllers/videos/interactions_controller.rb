class Videos::InteractionsController < ApplicationController
  respond_to :html, :json

  before_action :set_video

  def index
    @breadcrumbs = ["Mis Cursos", @video.course.name, "Videos", @video.name]
    @interactions = Interaction.includes(:user).where(video_id: params[:video_id])
    
    respond_with @interactions
  end

  def create
    interaction = Interaction.new interaction_params
    interaction.save

    respond_with interaction
  end

  private
  def set_video
    @video = Video.includes(:course).find params[:video_id]
  end

  def interaction_params
    params
      .require(:interaction)
      .permit([:user_id, :action, :seconds])
      .merge({ video_id: params[:video_id].to_i })
  end
end