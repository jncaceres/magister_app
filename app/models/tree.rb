class Tree < ActiveRecord::Base

  belongs_to :course
  belongs_to :video, inverse_of: :tree
  has_one :content, :dependent => :destroy
  has_many :content_questions, :dependent => :destroy
  has_many :ct_questions, :dependent => :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_one :initial_content_question, :class_name => "InitialContentQuestion", :dependent => :destroy
  has_one :initial_ct_question, :class_name => "InitialCtQuestion", :dependent => :destroy
  has_one :recuperative_content_question, :class_name => "RecuperativeContentQuestion", :dependent => :destroy
  has_one :recuperative_ct_question, :class_name => "RecuperativeCtQuestion", :dependent => :destroy
  has_one :deeping_content_question, :class_name => "DeepingContentQuestion", :dependent => :destroy
  has_one :deeping_ct_question, :class_name => "DeepingCtQuestion", :dependent => :destroy
  has_many :feedbacks, :dependent => :destroy

  has_one :initial_simple_feedback, :class_name => "InitialSimpleFeedback", :dependent => :destroy
  has_one :initial_complex_feedback, :class_name => "InitialComplexFeedback", :dependent => :destroy
  has_one :recuperative_simple_feedback, :class_name => "RecuperativeSimpleFeedback", :dependent => :destroy
  has_one :recuperative_complex_feedback, :class_name => "RecuperativeComplexFeedback", :dependent => :destroy
  has_one :deeping_simple_feedback, :class_name => "DeepingSimpleFeedback", :dependent => :destroy
  has_one :deeping_complex_feedback, :class_name => "DeepingComplexFeedback", :dependent => :destroy
  has_and_belongs_to_many :reports
  has_many :user_tree_performances, :dependent => :destroy

  validates_presence_of :content, :message => "Por favor, ingresa un contenido para evaluación"
  validates_presence_of :initial_content_question, :message => "Por favor, ingresa la Pregunta inicial de contenido"
  validates_presence_of :initial_ct_question, :message => "Por favor, ingresa la Pregunta inicial de pensamiento crítico"
  validates_presence_of :recuperative_content_question, :message => "Por favor, ingresa la Pregunta recuperativa de contenido"
  validates_presence_of :recuperative_ct_question, :message => "Por favor, ingresa la Pregunta recuperativa de pensamiento crítico"
  validates_presence_of :deeping_content_question, :message => "Por favor, ingresa la Pregunta de profundización de contenido"
  validates_presence_of :deeping_ct_question, :message => "Por favor, ingresa la Pregunta de profundización de pensamiento crítico"
  validates_presence_of :initial_simple_feedback, :message => "Por favor, ingresa el Feedback inicial para Contenido"
  validates_presence_of :initial_complex_feedback, :message => "Por favor, ingresa el Feedback inicial para Argumento"
  validates_presence_of :recuperative_simple_feedback, :message => "Por favor, ingresa el Feedback Pregunta Recuperativa para Contenido"
  validates_presence_of :recuperative_complex_feedback, :message => "Por favor, ingresa el Feedback Pregunta Recuperativa para Argumento"
  validates_presence_of :deeping_simple_feedback, :message => "Por favor, ingresa el Feedback Pregunta de profundización para Contenido"
  validates_presence_of :deeping_complex_feedback, :message => "Por favor, ingresa el Feedback Pregunta de profundización para Argumento"

  accepts_nested_attributes_for :content, :reject_if => lambda { |a| a[:text].blank? }, :allow_destroy => true
  #accepts_nested_attributes_for :content_questions, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true
  #accepts_nested_attributes_for :ct_questions, :reject_if => lambda { |a| a[:question].blank? }, :allow_destroy => true

  accepts_nested_attributes_for :initial_content_question, :allow_destroy => true
  accepts_nested_attributes_for :initial_ct_question, :allow_destroy => true
  accepts_nested_attributes_for :recuperative_content_question, :allow_destroy => true
  accepts_nested_attributes_for :recuperative_ct_question, :allow_destroy => true
  accepts_nested_attributes_for :deeping_content_question, :allow_destroy => true
  accepts_nested_attributes_for :deeping_ct_question, :allow_destroy => true

  accepts_nested_attributes_for :initial_simple_feedback, :allow_destroy => true
  accepts_nested_attributes_for :initial_complex_feedback, :allow_destroy => true
  accepts_nested_attributes_for :recuperative_simple_feedback, :allow_destroy => true
  accepts_nested_attributes_for :recuperative_complex_feedback, :allow_destroy => true
  accepts_nested_attributes_for :deeping_simple_feedback, :allow_destroy => true
  accepts_nested_attributes_for :deeping_complex_feedback, :allow_destroy => true
  accepts_nested_attributes_for :user_tree_performances, :allow_destroy => true

  delegate :text, to: :content
  delegate :to_s, to: :content
end
