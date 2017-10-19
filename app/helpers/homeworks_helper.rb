module HomeworksHelper
  def did_answer answer, phase
    !answer.send(phase).blank? or answer.send("image_#{phase}_1") or answer.send("image_#{phase}_2")
  end
end
