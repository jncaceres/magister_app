class AddTreeToVideos < ActiveRecord::Migration
  def change
    add_reference :videos, :tree, index: true, foreign_key: true
  end
end
