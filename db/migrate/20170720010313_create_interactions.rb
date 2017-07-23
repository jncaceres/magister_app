class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.references :video, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :action
      t.integer :seconds

      t.timestamps null: false
    end
  end
end
