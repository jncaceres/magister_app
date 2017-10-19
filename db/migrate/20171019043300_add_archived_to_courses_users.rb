class AddArchivedToCoursesUsers < ActiveRecord::Migration
  def change
    add_column :courses_users, :archived, :boolean, default: false
  end
end
