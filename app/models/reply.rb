class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :tree

  has_many :picks, dependent: :destroy

  enum stage: [:initial, :recuperative, :deeping, :finished]
end