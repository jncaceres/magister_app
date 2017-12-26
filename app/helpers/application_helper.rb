module ApplicationHelper
  def markdown content
    $markdown.render content
  end

  def bool_tag bool
    tag "span", class: "glyphicon glyphicon-ok" if bool
  end

  def fav_tag bool, empty=false
    return tag "span", class: "glyphicon glyphicon-star" if bool
    return tag "span", class: "glyphicon glyphicon-star-empty" if empty
  end
end
