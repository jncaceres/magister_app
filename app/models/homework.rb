class Homework < ActiveRecord::Base

  enum actual_phase: [:responder, :argumentar, :rehacer, :evaluar, :integrar]
  after_initialize :set_default, :if => :new_record?

  def set_default
    self.actual_phase ||= :responder
    self.upload ||= false
    self.current ||= false
    self.partners ||= false
  end

  has_and_belongs_to_many :users
  has_many :answers
  has_many :sinthesy, dependent: :destroy
  belongs_to :course
  has_attached_file :image, styles: {medium: "800x800>"}
  validates_attachment_content_type :image, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
end
