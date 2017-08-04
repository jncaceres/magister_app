class Video < ActiveRecord::Base
  belongs_to :course
  belongs_to :tree
  has_many :comments, inverse_of: :video

  before_save :embedded_url

  def extract_id
    if self.url.include? 'youtu'
      matched = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/.match(self.url)
      return matched[2]
    end
  end

  def embedded_url
    self.final_url = "https://www.youtube.com/embed/#{self.extract_id}"
  end
end
