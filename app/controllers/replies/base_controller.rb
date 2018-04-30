class Replies::BaseController < ApplicationController
  before_action :must_be_logged_in
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

    attp  = @reply.attempts.build stage: @reply.stage
    cpick = ContentChoice.where(id: c_id).map do |cc| @reply.picks.build selectable: cc, attempt: attp end
    tpick = CtChoice.where(id: p_id).map      do |ct| @reply.picks.build selectable: ct, attempt: attp end

    render 'show' and return if cpick.empty? or tpick.empty?

    @reply.save
    @oldstage = @reply.stage

    if is_right?(cpick) then # { OK }
      if is_right?(tpick) then # { OK, OK } -> redirect
        logger.warn "#{@reply.stage} is a success"
        @reply.send(on_success(@reply.stage) + "!")
      elsif @reply.attempts.send(@reply.stage).count < 1 # { OK, Error } -> simple feedback
        logger.warn "#{@reply.stage} giving feedback on error"
        @feedback = @tree.send("#{@reply.stage}_simple_feedback")
      else # >2 errors -> redirect
        logger.warn "#{@reply.stage} redirects to #{on_error @reply.stage}"
        @reply.send(on_error(@reply.stage) + "!")
      end
    elsif @reply.attempts.send(@reply.stage).count < 1 # { Error, any } -> complex feedback
      logger.warn "#{@reply.stage} giving complex feedback on error"
      @feedback = @tree.send("#{@reply.stage}_complex_feedback")
    else
      logger.warn "#{@reply.stage} redirects to #{on_error @reply.stage}"
      @reply.send(on_error(@reply.stage) + "!")
    end

    redirect_to tree_replies_between_path(@tree, stage: @oldstage)
  end

  private
  def set_tree
    @tree = Tree
      .includes(:content, content_questions: :content_choices, ct_questions: [:ct_choices, :ct_habilities])
      .find params[:tree_id]
  end

  def set_reply
    @reply = Reply.includes(:picks, :attempts).find_or_create_by(tree_id: @tree.id, user_id: current_user.id)
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
    case stage
      when 'initial' then 'recuperative'
      when 'recuperative' then 'deeping'
      when 'deeping' then 'finished'
      else 'finished'
    end
  end

  def on_success stage
    stage == "deeping" ? "finished" : "deeping"
  end

  def is_right? picks
    picks.any? and picks.all?(&:right) and picks.count == picks.first.selectable.question.choices.select(&:right).count
  end
end