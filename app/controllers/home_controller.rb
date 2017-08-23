class HomeController < ApplicationController
  before_action :set_breadcrumbs

  respond_to :html, :json
  def home
    if user_signed_in?
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

end
