class AddAttemptToPick < ActiveRecord::Migration
  def change
    add_reference :picks, :attempt, index: true, foreign_key: true
  end
end
