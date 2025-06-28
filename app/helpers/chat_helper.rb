module ChatHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    extensions = {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      autolink: true,
      tables: true,
      underline: true,
      highlight: true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end
end
