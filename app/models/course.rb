class Course < ActiveRecord::Base
  has_many :course_users, inverse_of: :course
  has_many :users, through: :course_users
  has_many :homeworks, inverse_of: :course, dependent: :destroy
  has_many :trees, dependent: :destroy
  has_many :user_tree_performances, through: :trees
  has_many :reports, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :feedbacks, through: :trees
  #accepts_nested_attributes_for :trees, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  validates :name,
    presence: true
  validates :course_code,
    presence: true

  def full_name
    "[#{course_code}] #{name}"
  end
end
