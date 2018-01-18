class Attempt < ActiveRecord::Base
  belongs_to :reply
  has_many :picks, inverse_of: :attempt

  enum stage: [:initial, :recuperative, :deeping, :finished]

  scope :at_stage, -> (stage) { select do |att| att.send(stage + "?") end }
end
