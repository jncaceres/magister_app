class Replies::BaseController < ApplicationController
  before_action :set_tree
  before_action :set_reply
  before_action :set_questions
  before_action :set_breadcrumbs

  respond_to :html, :json

  private
  def set_tree
    @tree = Tree
      .includes(:content, content_questions: :content_choices, ct_questions: :ct_choices)
      .find params[:tree_id]
  end

  def set_reply
    @reply = Reply.includes(:picks).find_or_create_by(tree_id: @tree.id, user_id: current_user.id)
    @reply.initial! unless @reply.stage
  end

  def set_breadcrumbs
    @breadcrumbs = ["Evaluaciones Formativas", @tree.text, current_user.full_name, t(controller_name.singularize)]
  end

  def set_questions
    @content = @tree.content_questions.to_a.select do |cq|
      cq.type == @reply.stage.capitalize + "ContentQuestion"
    end.first

    @ct      = @tree.ct_questions.to_a.select do |cq|
      cq.type == @reply.stage.capitalize + "CtQuestion"
    end.first
  end
end