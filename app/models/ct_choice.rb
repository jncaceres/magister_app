class CtChoice < ActiveRecord::Base
  belongs_to :ct_question
  belongs_to :question, class_name: CtQuestion, foreign_key: :ct_question_id
  has_many :picks, as: :selectable
  has_many :ct_habilities, through: :ct_question

  delegate :to_s, to: :text
end
