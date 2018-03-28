class Replies::BetweensController < Replies::BaseController
  before_action :set_breadcrumbs
    respond_to :html, :json
    
    def show
      @stage = params[:stage] || "initial"
      @picks = @reply.attempts.at_stage(@stage).last.picks

      cpick = @picks.content
      tpick = @picks.ct

      @feedback = Array.new
      @feedback << @tree.send(@stage + "_simple_feedback")  unless is_right?(cpick)
      @feedback << @tree.send(@stage + "_complex_feedback") unless is_right?(tpick)
    end
  
    private
    def set_breadcrumbs
      @tree = Tree.find params[:tree_id]
      @breadcrumbs = ["Trees", @tree.text, current_user.full_name, controller_name]
    end
  end
