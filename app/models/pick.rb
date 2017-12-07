class Pick < ActiveRecord::Base
  belongs_to :reply
  belongs_to :attempt
  belongs_to :selectable, polymorphic: true

  has_many :content_options, source: :selectable, source_type: "ContentChoice"
  has_many :ct_options,      source: :selectable, source_type: "CtChoice"

  delegate :right, to: :selectable, allow_nil: true
  scope :correct, -> ()     {
    joins("INNER JOIN content_choices cc on picks.selectable_type = 'ContentChoice' and cc.id = picks.selectable_id")
    .joins("INNER JOIN ct_choices ct on picks.selectable_type = 'CtChoice' and ct.id = picks.selectable_id")
    .where('cc.right or ct.right')
  }
  scope :incorrect, -> ()   {
    joins("INNER JOIN content_choices cc on picks.selectable_type = 'ContentChoice' and cc.id = picks.selectable_id")
    .joins("INNER JOIN ct_choices ct on picks.selectable_type = 'CtChoice' and ct.id = picks.selectable_id")
    .where('not (cc.right or ct.right)')
  }
  scope :content, -> ()     { where(selectable_type: "ContentChoice" ) }
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
