class Teclera < ActiveRecord::Base
  validates :cantidad, presence: true
  belongs_to :course
end
