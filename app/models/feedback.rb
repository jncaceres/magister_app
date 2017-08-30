class Feedback < ActiveRecord::Base
  belongs_to :tree

  validates :text,
    presence: true
end
