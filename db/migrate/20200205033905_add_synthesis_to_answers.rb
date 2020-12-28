class AddSynthesisToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :sinthesys_id, :integer
    add_column :answers, :grade_sinthesys, :integer
  end
end
