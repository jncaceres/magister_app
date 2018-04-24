class Replies::BetweensController < Replies::BaseController
  before_action :set_breadcrumbs
    respond_to :html, :json
    
    def show
      @stage = params[:stage] || "initial"
      @picks = @reply.attempts.at_stage(@stage).last.picks

      cpick = @picks.content
      tpick = @picks.ct

      @feedback = Array.new
      @feedback << @tree.send(@stage + "_simple_feedback")  unless is_right?(cpick) or @stage == "finished"
      @feedback << @tree.send(@stage + "_complex_feedback") unless is_right?(tpick) or @stage == "finished"
    end
  end
