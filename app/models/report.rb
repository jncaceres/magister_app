class Report < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :trees

  validates :name,
    presence: true
  validates :trees,
    presence: true
end
