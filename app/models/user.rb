# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  teacher                :boolean          default(FALSE)
#  ta                     :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  enum role: [:alumno, :ayudante, :profesor]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :alumno
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :activities
  has_many :answers
  has_many :replies
  has_many :picks, through: :replies
  has_many :questions, through: :answers
  has_many :comments, inverse_of: :user, dependent: :nullify
  # has_and_belongs_to_many :courses
  has_many :course_users, -> { where(archived: false) }
  has_many :courses, through: :course_users
  has_many :user_tree_performances, :dependent => :destroy

  scope :students, -> () { where(role: 0) }

  def full_name
    self.first_name + " " + self.last_name
  end

  def signature
    '[' + first_name.first + last_name.first + ']'
  end
end
