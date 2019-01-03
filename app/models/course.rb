class Course < ActiveRecord::Base
  has_many :course_users, inverse_of: :course
  has_many :users, through: :course_users
  has_many :homeworks, inverse_of: :course, dependent: :destroy
  has_many :trees, dependent: :destroy
  has_many :user_tree_performances, through: :trees
  has_many :reports, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :feedbacks, through: :trees
  has_many :tecleras
  #accepts_nested_attributes_for :trees, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  before_validation :set_default_course_code

  validates :name,
    presence: true,
    uniqueness: true
  validates :course_code,
    presence: true,
    uniqueness: true

  def set_default_course_code
    self.course_code ||= description + id.to_s
  end

  def full_name
    "[#{course_code}] #{name}"
  end
end
