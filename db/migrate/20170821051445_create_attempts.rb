class CreateAttempts < ActiveRecord::Migration
  def change
    create_table :attempts do |t|
      t.references :reply, index: true, foreign_key: true
      t.integer :stage

      t.timestamps null: false
    end
  end
end
