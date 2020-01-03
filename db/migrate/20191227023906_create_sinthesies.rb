class CreateSinthesies < ActiveRecord::Migration
  def change
    create_table :sinthesies do |t|
      t.text :sinthesys
      t.string :phase
      t.references :homework, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
