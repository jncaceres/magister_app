class Assignment < ActiveRecord::Base
  has_many :assignment_schedules
  has_many :corrections, through: :assignment_schedules
end
