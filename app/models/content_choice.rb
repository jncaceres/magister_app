class ContentChoice < ActiveRecord::Base
  belongs_to :content_question
  belongs_to :question, class_name: ContentQuestion, foreign_key: :content_question_id
  has_many :picks, as: :selectable

  delegate :to_s, to: :text
end
