class CreateTecleras < ActiveRecord::Migration
  def change
    create_table :tecleras do |t|

      t.timestamps null: false
    end
  end
end
