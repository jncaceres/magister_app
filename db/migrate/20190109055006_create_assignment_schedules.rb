class CreateAssignmentSchedules < ActiveRecord::Migration
  def change
    create_table :assignment_schedules do |t|

      t.timestamps null: false
    end
  end
end
