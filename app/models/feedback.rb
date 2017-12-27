class Feedback < ActiveRecord::Base
  belongs_to :tree

  delegate :to_s, to: :text

  validates :text,
    presence: true
end
