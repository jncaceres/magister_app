class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.references :reply, index: true, foreign_key: true
      t.references :selectable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
