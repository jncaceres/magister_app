class Videos::UnitsController < ApplicationController
  def index
    @videos = Video
      .where(course_id: current_user.current_course_id)
      .where("videos.unit is not null")
  end

  def show
    @videos = Video
      .where(course_id: current_user.current_course_id)
      .where(unit: params[:id])
  end
end
