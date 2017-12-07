class ReportsController < ApplicationController
  before_action :set_course
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_breadcrumbs

  respond_to :html, :json

  @@includes = { trees: :content }

  def index
    @reports = @course.reports
  end

  def new
    @report  = @course.reports.build
    @trees   = @course.trees.includes(:content)
  end

  def create
    @report = @course.reports.build report_params

    if @report.save
      redirect_to [@course, @report]
    else
      @reports = @course.reports
      render 'new'
    end
  end

  def show
    respond_with @report
  end

  def edit
    @trees   = @course.trees.includes(:content)
  end

  def update
    @report.update report_params

    redirect_to [@course, @report]
  end

  def destroy
    @report.destroy

    redirect_to course_reports_path(@report.course)
  end

  private
  def set_course
    @course = Course.includes({ reports: @@includes }).find params[:course_id]
  end

  def set_report
    @report = @course.reports.find params[:id]
  end

  def set_breadcrumbs
    @breadcrumbs = [@course.name, "Reportes"]
  end

  def report_params
    params.require(:report).permit(:name, tree_ids: [])
  end
end
