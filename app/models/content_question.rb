class ContentQuestion < ActiveRecord::Base
  belongs_to :tree
  has_many :content_choices, :dependent => :destroy
  accepts_nested_attributes_for :content_choices, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true

  has_many :choices, class_name: ContentChoice

  validates :question,
    presence: true
end
