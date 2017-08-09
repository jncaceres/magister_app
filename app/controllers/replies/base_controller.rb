class Replies::BaseController < ApplicationController
  before_action :set_tree
  before_action :set_reply
  before_action :set_questions
  before_action :set_breadcrumbs

  respond_to :html, :json

  def show
    redirect_to send("tree_replies_#{@reply.stage}_path", @tree) unless @reply.send(controller_name.singularize + "?")
  end

  def update
    c_id  = params[:content_pick].try(:[], 'selectable_id')
    c_id  = c_id.reject(&:empty?) if c_id.is_a? Array
    p_id  = params[:ct_pick].try(:[], 'selectable_id')
    p_id  = p_id.reject(&:empty?) if p_id.is_a? Array

    cpick = ContentChoice.where(id: c_id).map do |cc| @reply.picks.build selectable: cc end
    tpick = CtChoice.where(id: p_id).map      do |ct| @reply.picks.build selectable: ct end

    render json: { cpick: is_right?(cpick), tpick: is_right?(tpick) } and return

    @reply.save

    if is_right?(cpick) then # { OK }
      if is_right?(tpick) then # { OK, OK } -> redirect
        @reply.send(on_success(@reply.stage) + "!")

        redirect_to send("tree_replies_#{@reply.stage}_path", @tree)
      elsif @reply.picks.count <= ([cpick].flatten.count * 3) # { OK, Error } -> simple feedback
        @feedback = @tree.send("#{@reply.stage}_simple_feedback")

        render 'show'
      else # >3 errors -> redirect
        @reply.send(on_error(@reply.stage) + "!")

        redirect_to tree_replies_finished_path(@tree)
      end
    elsif @reply.picks.count <= ([cpick].flatten.count * 3) # { Error, any } -> complex feedback
      @feedback = @tree.deeping_complex_feedback

      render 'show'
    else
      @reply.finished!

      redirect_to tree_replies_finished_path(@tree)
    end
  end

  private
  def set_tree
    @tree = Tree
      .includes(:content, content_questions: :content_choices, ct_questions: [:ct_choices, :ct_habilities])
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

  def on_error stage
    stage == "initial" ? "recuperative" : "finished"
  end

  def on_success stage
    stage == "deeping" ? "finished" : "deeping"
  end

  def is_right? picks
    picks.all?(&:right) and picks.count == picks.first.selectable.question.choices.select(&:right).count
  end
end