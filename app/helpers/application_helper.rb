module ApplicationHelper
  def render_if_exists(path, partial, options={})
    filename = Rails.root.join("app", "views", path, "_#{partial}.html.erb")
    if File.exists?(filename)
      render(path+partial, options)
    else
      "not found: #{filename}"
    end
  end
end
