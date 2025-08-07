module Admin::PagesHelper
  def title_with_path(page)
    "#{page.title} (#{page.full_path})"
  end
end