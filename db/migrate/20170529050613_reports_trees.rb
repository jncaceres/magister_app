class ReportsTrees < ActiveRecord::Migration
  def change
    create_table :reports_trees, :id => false do |t|
      t.integer :report_id, null: false
      t.integer :tree_id, null: false
    end
    add_index :reports_trees, ["report_id", "tree_id"]
  end
end
