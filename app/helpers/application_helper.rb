module ApplicationHelper
  def markdown content
    $markdown.render content
  end
end
