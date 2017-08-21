class Replies::InteractionsController < ApplicationController
  before_action :set_breadcrumbs

  respond_to :html, :json
  
  def show
    @replies = Reply.includes(:user).where(tree_id: @tree.id).order('users.last_name', :stage)
  end

  private
  def set_breadcrumbs
    @tree = Tree.find params[:tree_id]
    @breadcrumbs = ["Trees", @tree.text, current_user.full_name, controller_name]
  end
end
