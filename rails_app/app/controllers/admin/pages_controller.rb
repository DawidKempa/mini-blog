module Admin
  class PagesController < Admin::BaseController
    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :set_page, only: [:edit, :update, :destroy]

    def index
      @pages = Page.order(:position)
    end

    def new
      @page = Page.new
    end

    def show
      path = params[:path]
      @page = Page.find_by_full_path(path)
      @child_pages = @page.children.order(:position) if @page
      redirect_to admin_pages_path, alert: 'Strona nie została znaleziona' unless @page
    end

    def create
      @page = Page.new(page_params.merge(user: current_user))
      if @page.save
        redirect_to admin_pages_path, notice: "Strona została dodana!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @page = Page.find(params[:id])
    end

    def update
      if @page.update(page_params)
        redirect_to admin_pages_path, notice: "Strona zaktualizowana!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @page = Page.find(params[:id])
      @page.destroy
      redirect_to admin_pages_path, notice: 'Strona została usunięta.'
    end


    def export_to_pdf
      @pages = Page.order(:position)

      html = render_to_string(
        template: 'admin/pages/index',
        layout: 'pdf',
        formats: [:html],
        encoding: 'UTF-8'
      )

      pdf = Grover.new(html, browser_path: '/usr/bin/chromium-browser').to_pdf

      send_data pdf,
        filename: 'zarzadzanie-stronami.pdf',
        type: 'application/pdf',
        disposition: 'inline'
    end

    private

    def set_page
      @page = if params[:id].to_s.match?(/\A\d+\z/)
                Page.find(params[:id])
              else
                Page.find_by(slug: params[:id])
              end
      
      return if @page

      redirect_to admin_pages_path, alert: 'Strona nie została znaleziona'
    end

    def page_params
      params.require(:page).permit(:title, :slug, :content, :parent_id, :published, :position)
    end

    def authorize_admin!
      unless current_user&.admin?
        redirect_to root_path, alert: 'Brak uprawnień'
      end
    end
  end
end