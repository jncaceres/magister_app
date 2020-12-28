module HomeworksHelper
  def did_answer answer, phase, user
    if phase == "argumentar"
      if user.argument == 0
        if answer.nil?
          return false
        else
          if answer.grade_sinthesys.nil?
            return false
          else
            return true
          end
        end
      else
        if answer.nil?
          return false
        else
          if answer.grade_argue_1 != nil or answer.grade_argue_2 != nil
            return true
          else
            return false
          end
        end
      end
    elsif phase == "rehacer"
      if answer.nil?
        return false
      else
        if answer.rehacer.nil?
          return false
        else
          return true
        end
      end
    else
      return false if answer.nil?
      !answer.send(phase).blank? or answer.send("image_#{phase}_1") or answer.send("image_#{phase}_2")
    end
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
        elsif grade_argue_n == "grade_sinthesys"
            if answer.grade_sinthesys.nil?
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
