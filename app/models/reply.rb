class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :tree

  has_many :picks, inverse_of: :reply, dependent: :destroy
  has_many :attempts, inverse_of: :reply, dependent: :destroy

  enum stage: [:initial, :recuperative, :deeping, :finished]
end