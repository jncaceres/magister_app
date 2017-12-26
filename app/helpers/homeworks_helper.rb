module HomeworksHelper
  def did_answer answer, phase
    return false if answer.nil?
    !answer.send(phase).blank? or answer.send("image_#{phase}_1") or answer.send("image_#{phase}_2")
  end
end
