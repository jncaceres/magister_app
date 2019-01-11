class Attachment < ActiveRecord::Base
  has_attached_file :essay
  validates_attachment_content_type :essay, content_type: ["application/zip", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/msword"]
  belongs_to :user
  belongs_to :assignment_schedule
  has_one :correction
  has_one :assignment, through: :assignment_schedule

  def assignment_number
    return assignment.number
  end
end
