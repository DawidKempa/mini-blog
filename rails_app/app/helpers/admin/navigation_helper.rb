module Admin::NavigationHelper
  def admin_nav_link_to(name, path, icon = nil)
    active = current_page?(path) || 
             controller_name == path.split('/').second
             
    content_tag :li, class: "sidebar-item #{'active' if active}" do
      link_to path, class: "sidebar-link" do
        concat content_tag(:i, "", class: "fas fa-#{icon}") if icon
        concat content_tag(:span, name)
      end
    end
  end
end