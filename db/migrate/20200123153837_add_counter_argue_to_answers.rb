class AddCounterArgueToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :counter_argue, :integer, :default => 0
    add_column :answers, :corrector_id_2, :integer, :default => 0
  end
end
