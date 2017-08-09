class CtQuestion < ActiveRecord::Base
  belongs_to :tree
  has_many :ct_choices, :dependent => :destroy
  has_many :ct_habilities, :dependent => :destroy
  accepts_nested_attributes_for :ct_choices, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :ct_habilities, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

  has_many :choices, class_name: CtChoice
end
