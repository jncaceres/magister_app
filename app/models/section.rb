class Section < ActiveRecord::Base
  belongs_to :clase
  belongs_to :term
end
