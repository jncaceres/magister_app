module HomeworksHelper
  def did_answer answer, phase
    return false if answer.nil?
    !answer.send(phase).blank? or answer.send("image_#{phase}_1") or answer.send("image_#{phase}_2")
  end

  def have_grade? answer, grade_argue_n, phase
    if phase == "argumentar"
      if answer != nil
        if grade_argue_n == "grade_argue_1"
          if answer.grade_argue_1.nil?
            return false
          else
            return true
          end
        elsif grade_argue_n == "grade_argue_2"
          if answer.grade_argue_2.nil?
            return false
          else
            return true
          end
        end
      end
    elsif phase == "rehacer"
      if answer != nil
        if grade_argue_n == "grade_argue_1"
          if answer.grade_eval_1.nil?
            return false
          else
            return true
          end
        elsif grade_argue_n == "grade_argue_2"
          if answer.grade_eval_2.nil?
            return false
          else
            return true
          end
        end
      end
    end
  end

end
