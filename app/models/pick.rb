class Pick < ActiveRecord::Base
  belongs_to :reply
  belongs_to :selectable, polymorphic: true

  delegate :right, to: :selectable, allow_nil: true
end
