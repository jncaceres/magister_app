class Replies::RecuperativesController < Replies::BaseController
  def show
    redirect_to send("tree_replies_#{@reply.stage}_path", @tree) unless @reply.recuperative?
  end

  def update
    c_id  = params[:content_pick].try(:[], 'selectable_id')
    p_id  = params[:ct_pick].try(:[], 'selectable_id')
    cpick = @reply.picks.build selectable: ContentChoice.where(id: c_id).first
    tpick = @reply.picks.build selectable: CtChoice.where(id: p_id).first

    @reply.save

    if cpick.right then # { OK }
      if tpick.right then # { OK, OK } -> redirect
        @reply.deeping!

        redirect_to tree_replies_deeping_path(@tree)
      elsif @reply.picks.count <= 5 # { OK, Error } -> simple feedback
        @feedback = @tree.recuperative_simple_feedback

        render 'show'
      else # >3 errors -> redirect
        @reply.finished!

        redirect_to tree_replies_finished_path(@tree)
      end
    elsif @reply.picks.count <= 5 # { Error, any } -> complex feedback
      @feedback = @tree.recuperative_complex_feedback

      render 'show'
    else
      @reply.finished!

      redirect_to tree_replies_finished_path(@tree)
    end
  end
end
