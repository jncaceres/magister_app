# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  content     :string(500)
#  upload      :boolean          default(FALSE)
#  user_id     :integer
#  question_id :integer
#  question_phase :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  phase       :integer

class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
end
