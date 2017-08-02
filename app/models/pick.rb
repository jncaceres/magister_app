class Pick < ActiveRecord::Base
  belongs_to :reply
  belongs_to :selectable, polymorphic: true

  delegate :right, to: :selectable
end
