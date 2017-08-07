class AddVideoToTree < ActiveRecord::Migration
  def change
    remove_column :trees, :video, :string
    add_reference :trees, :video, index: true, foreign_key: true
    add_column :trees, :active, :boolean, default: false
  end
end
