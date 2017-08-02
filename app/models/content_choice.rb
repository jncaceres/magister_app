class ContentChoice < ActiveRecord::Base
  belongs_to :content_question
  has_many :picks, as: :selectable

  delegate :to_s, to: :text
end
