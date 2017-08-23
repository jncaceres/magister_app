class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :tree

  has_many :picks, inverse_of: :reply, dependent: :destroy
  has_many :attempts, inverse_of: :reply, dependent: :destroy

  has_many :content_options, through: :picks, source: :selectable, source_type: "ContentChoice"
  has_many :ct_options,      through: :picks, source: :selectable, source_type: "CtChoice"

  enum stage: [:initial, :recuperative, :deeping, :finished]
end