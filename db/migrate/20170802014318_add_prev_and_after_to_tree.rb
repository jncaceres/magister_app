class AddPrevAndAfterToTree < ActiveRecord::Migration
  def change
    add_column :trees, :prev, :text
    add_column :trees, :after, :text
  end
end
