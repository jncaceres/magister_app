renderer  = Redcarpet::Render::HTML.new(render_options = {})
$markdown = Redcarpet::Markdown.new(renderer, extensions = {autolink: true, tables: true})