class AddUnitToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :unit, :integer
  end
end
