class Comment < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  belongs_to :parent, class_name: "Comment"

  has_many :children, class_name: "Comment", foreign_key: :parent_id, inverse_of: :parent

  validates :video,
    presence: true
end
