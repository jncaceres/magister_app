class ContentQuestion < ActiveRecord::Base
  belongs_to :tree
  has_many :content_choices, :dependent => :destroy
  accepts_nested_attributes_for :content_choices, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true

  has_many :choices, class_name: ContentChoice

  validates :question,
    presence: true

  validate :has_correct

  def has_correct
    errors.add :choices, "Se necesita al menos una alternativa correcta" unless self.choices.select(&:right).any?
  end
end
