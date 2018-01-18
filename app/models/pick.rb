class Pick < ActiveRecord::Base
  belongs_to :reply
  belongs_to :attempt
  belongs_to :selectable, polymorphic: true

  has_many :content_options, source: :selectable, source_type: "ContentChoice"
  has_many :ct_options,      source: :selectable, source_type: "CtChoice"

  delegate :right, to: :selectable, allow_nil: true
  scope :correct, -> ()     {
    select(&:right)
  }
  scope :incorrect, -> ()   {
    reject(&:right)
  }
  scope :content, -> ()     { where(selectable_type: "ContentChoice" ) }
  scope :ct,      -> ()     { where(selectable_type: "CtChoice") }
  scope :of_type, -> (type) {
    where(selectable_type: "CtChoice")
      .includes(selectable: :ct_habilities)
      .select do |p|
        p.selectable.ct_habilities.find { |ch|
          ch.active && ch.name == type
        }
      end
  }
end
