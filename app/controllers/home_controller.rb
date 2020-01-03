class HomeController < ApplicationController
  before_action :set_breadcrumbs
  after_action :allow_iframe

  respond_to :html, :json
  def home
    if user_signed_in?
      current_user.update(current_course_id: nil)
      redirect_to users_path
    end
  end

  def index
  end

  def test
    @report = Report.find(22)
    respond_with @report, include: [trees: [:content]]
  end

  private

  def set_breadcrumbs
    @breadcrumbs = []
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end
