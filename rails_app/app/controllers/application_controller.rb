class ApplicationController < ActionController::Base
  helper :all
  allow_browser versions: :modern
  before_action :authenticate_user!

  def authorize_admin!
    unless current_user&.admin?
      flash.now[:alert] = "Brak uprawnień"
      render template: "errors/forbidden", status: :forbidden
    end
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    else
      authenticated_root_path
    end
  end
end
