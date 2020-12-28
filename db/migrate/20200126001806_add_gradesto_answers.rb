class AddGradestoAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :grade_argue_1, :integer
    add_column :answers, :grade_argue_2, :integer
    add_column :answers, :grade_eval_1, :integer
    add_column :answers, :grade_eval_2, :integer
  end
end
