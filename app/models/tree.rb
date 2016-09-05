class Tree < ActiveRecord::Base

  belongs_to :course
  has_one :content, :dependent => :destroy
  #has_many :content_questions, :dependent => :destroy
  #has_many :ct_questions, :dependent => :destroy
  has_one :initial_content_question, :class_name => "InitialContentQuestion", :dependent => :destroy
  has_one :initial_ct_question, :class_name => "InitialCtQuestion", :dependent => :destroy
  has_one :recuperative_content_question, :class_name => "RecuperativeContentQuestion", :dependent => :destroy
  has_one :recuperative_ct_question, :class_name => "RecuperativeCtQuestion", :dependent => :destroy
  has_one :deeping_content_question, :class_name => "DeepingContentQuestion", :dependent => :destroy
  has_one :deeping_ct_question, :class_name => "DeepingCtQuestion", :dependent => :destroy
  has_many :feedbacks, :dependent => :destroy

  #has_many :content_choices, through: :content_questions, :dependent => :destroy
  #has_many :ct_choices, through: :ct_questions, :dependent => :destroy

  #has_many :initial_content_choices, :class_name => "ContenChoice", through: :initial_content_question: :dependent => :destroy
  #has_many :initial_content_choices, :class_name => "ContenChoice", through: :initial_content_question: :dependent => :destroy
  #has_many :initial_content_choices, :class_name => "ContenChoice", through: :initial_content_question: :dependent => :destroy
  #has_many :initial_content_choices, :class_name => "ContenChoice", through: :initial_content_question: :dependent => :destroy
  #has_many :initial_content_choices, :class_name => "ContenChoice", through: :initial_content_question: :dependent => :destroy
  #has_many :initial_content_choices, :class_name => "ContenChoice", through: :initial_content_question: :dependent => :destroy




  accepts_nested_attributes_for :content, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true
  #accepts_nested_attributes_for :content_questions, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true
  #accepts_nested_attributes_for :ct_questions, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true

  accepts_nested_attributes_for :initial_content_question, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :initial_ct_question, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :recuperative_content_question, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :recuperative_ct_question, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :deeping_content_question, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :deeping_ct_question, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true
  
end
