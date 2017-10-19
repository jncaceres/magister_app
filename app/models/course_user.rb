class CourseUser < ActiveRecord::Base
  self.table_name = 'courses_users'

  belongs_to :course
  belongs_to :user
end
