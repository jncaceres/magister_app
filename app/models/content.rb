class Content < ActiveRecord::Base
  belongs_to :tree

  delegate :to_s, to: :text
end
