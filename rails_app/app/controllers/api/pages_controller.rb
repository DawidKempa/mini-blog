module Api 
  class PagesController < ApplicationController
    def index
      @pages = Page.roots.published.order(:position)
    end

    def show
      path = params[:path] || params[:id]
      @page = Page.find_by_full_path(path)
      
      unless @page
        redirect_to pages_path, alert: 'Strona nie została znaleziona'
      end
    end
  end
end