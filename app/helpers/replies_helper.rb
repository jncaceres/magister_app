module RepliesHelper
  def format_choice obj, picks=[]
    if picks.find do |p| p.selectable == obj end then
      content_tag :span, obj.text, class: (obj.right ? 'correct' : 'incorrect')
    else
      content_tag :span, obj.text
    end
  end
end
