class CtChoice < ActiveRecord::Base
  belongs_to :ct_question
  has_many :picks, as: :selectable

  delegate :to_s, to: :text
end
