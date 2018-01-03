# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  content     :string(500)
#  upload      :boolean          default(FALSE)
#  user_id     :integer
#  question_id :integer
#  question_phase :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  phase       :integer

class Answer < ActiveRecord::Base

  belongs_to :user
  belongs_to :homework

  has_attached_file :image_responder_1, styles: {medium: "800x800>"}
  has_attached_file :image_responder_2, styles: {medium: "800x800>"}
  has_attached_file :image_argumentar_1, styles: {medium: "800x800>"}
  has_attached_file :image_argumentar_2, styles: {medium: "800x800>"}
  has_attached_file :image_rehacer_1, styles: {medium: "800x800>"}
  has_attached_file :image_rehacer_2, styles: {medium: "800x800>"}
  has_attached_file :image_evaluar_1, styles: {medium: "800x800>"}
  has_attached_file :image_evaluar_2, styles: {medium: "800x800>"}
  has_attached_file :image_integrar_1, styles: {medium: "800x800>"}
  has_attached_file :image_integrar_2, styles: {medium: "800x800>"}
  validates_attachment_content_type :image_responder_1, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_responder_2, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_argumentar_1, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_argumentar_2, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_rehacer_1, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_rehacer_2, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_evaluar_1, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_evaluar_2, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_integrar_1, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  validates_attachment_content_type :image_integrar_2, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]

  scope :has_answered, -> (phase) { where("
    answers.#{phase} is not null or
    answers.image_#{phase}_1_file_name is not null or
    answers.image_#{phase}_2_file_name is not null") }
end
