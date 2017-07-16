class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :course_id
      t.float :interpretation_sc
      t.float :analysis_sc
      t.float :evaluation_sc
      t.float :inference_sc
      t.float :explanation_sc
      t.float :selfregulation_sc
      t.float :content_sc
      t.timestamps null: false
    end
    add_index "reports", "course_id"
  end
end
