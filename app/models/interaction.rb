class Interaction < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :video,
    presence: true
  validates :user,
    presence: true
end
