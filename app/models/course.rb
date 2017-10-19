class Course < ActiveRecord::Base
  has_many :course_users, inverse_of: :course
  has_many :users, through: :course_users
  has_many :homeworks
  has_many :trees
  has_many :user_tree_performances, through: :trees
  has_many :reports
  has_many :videos
  has_many :feedbacks, through: :trees
  #accepts_nested_attributes_for :trees, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
