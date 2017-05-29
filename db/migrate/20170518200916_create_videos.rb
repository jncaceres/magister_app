class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :url
      t.string :name
      t.references :course, index: true, foreign_key: true
      t.string :final_url

      t.timestamps null: false
    end
  end
end
