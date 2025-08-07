class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :check_admin_role

  private

  def check_admin_role
    redirect_to root_path, alert: "Nie masz uprawnień" unless current_user.admin?
  end

  def render_pdf(template_path, filename:)
    html = render_to_string(template: template_path, layout: 'pdf', formats: [:html])
    pdf = Grover.new(html, grover_options).to_pdf

    send_data pdf,
      filename: filename,
      type: 'application/pdf',
      disposition: 'inline'
  end

  def grover_options
    {
      format: 'A4',
      margin: { top: '20mm', bottom: '20mm', left: '10mm', right: '10mm' },
      display_header_footer: true,
      header_template: '<div style="font-size: 8px;"></div>',
      footer_template: '<div style="font-size: 8px; text-align: center;">Strona <span class="pageNumber"></span> z <span class="totalPages"></span></div>'
    }
  end
  
end
