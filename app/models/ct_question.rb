class CtQuestion < ActiveRecord::Base
  belongs_to :tree
  has_many :ct_choices, :dependent => :destroy
  has_many :ct_habilities, :dependent => :destroy
  accepts_nested_attributes_for :ct_choices, :allow_destroy => true
  accepts_nested_attributes_for :ct_habilities, :allow_destroy => true

  has_many :choices, class_name: CtChoice

  validates :question,
    presence: true
  
  validate :has_correct

  def has_correct
    unless self.choices.select(&:right).any? or self.ct_choices.select(&:right).any? then
      errors.add :choices, "Se necesita al menos una alternativa correcta"
    end
  end
end
