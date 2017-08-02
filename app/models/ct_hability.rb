class CtHability < ActiveRecord::Base
  belongs_to :ct_question
  has_many :ct_subhabilities
  accepts_nested_attributes_for :ct_subhabilities, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  
  scope :actives, -> () { where(active: true) }
end
