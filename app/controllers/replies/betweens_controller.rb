class Replies::BetweensController < Replies::BaseController
  before_action :set_breadcrumbs
  
    respond_to :html, :json
    
    def show
      @stage = params[:stage] || "initial"
      @picks = @reply.attempts.at_stage(@stage).last.picks
    end
  
    private
    def set_breadcrumbs
      @tree = Tree.find params[:tree_id]
      @breadcrumbs = ["Trees", @tree.text, current_user.full_name, controller_name]
    end
  end
