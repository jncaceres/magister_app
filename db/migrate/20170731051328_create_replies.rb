class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :user, index: true, foreign_key: true
      t.references :tree, index: true, foreign_key: true
      t.integer :stage

      t.timestamps null: false
    end
  end
end
