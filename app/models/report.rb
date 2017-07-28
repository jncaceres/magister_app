class Report < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :trees
  has_many :user_tree_performances, through: :trees
  @n_total = [0]
end
