class Attempt < ActiveRecord::Base
  belongs_to :reply

  enum stage: [:initial, :recuperative, :deeping, :finished]

  scope :at_stage, -> (stage) { send(stage) }
end
