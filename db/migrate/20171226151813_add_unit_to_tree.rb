class AddUnitToTree < ActiveRecord::Migration
  def change
    add_column :trees, :unit, :integer
  end
end
