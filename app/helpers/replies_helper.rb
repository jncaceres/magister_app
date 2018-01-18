module RepliesHelper
  def format_choice obj, picks=[]
    if picks.find do |p| p.selectable == obj end then
      content_tag :span, obj.text, class: (obj.right ? 'correct' : 'incorrect')
    else
      content_tag :span, obj.text
    end
  end

  def choice_mode obj
    obj.choices.select(&:right).count > 1 ? :check_boxes : :radio_buttons
  end

  def is_right? picks
    total = picks.map(&:selectable).map(&:question).map(&:choices).flatten.select(&:right).count
    !picks.empty? and picks.all?(&:right) and picks.count == total
  end
end
