module Admin
  class PdfController < Admin::BaseController
    def export
      original_url = url_for(controller: params[:controller_name], action: params[:action_name], only_path: false)
      base_url = ENV.fetch('APP_BASE_URL', 'http://localhost:3000')

      uri = URI.parse(original_url)
      uri.host = URI.parse(base_url).host
      uri.port = URI.parse(base_url).port

      token = ENV['PDF_TOKEN'] || Rails.application.credentials.pdf_token
      uri.query = [uri.query, "auth_token=#{token}"].compact.join("&")

      url_for_sidekiq = uri.to_s

      filename = "#{params[:controller_name]}-#{params[:action_name]}-#{Time.current.to_i}.pdf"
      output_path = Rails.root.join("tmp/pdfs", filename)

      PdfExportJob.perform_async(url_for_sidekiq, output_path.to_s)

      redirect_to admin_download_pdf_path(filename: filename), notice: "PDF się generuje, spróbuj za chwilę"
    end



    def download
      filename = params[:filename]
      path = Rails.root.join('tmp/pdfs', filename)

      if File.exist?(path)
        send_file path, filename: filename, type: 'application/pdf', disposition: 'inline'
      else
        render plain: "PDF jeszcze niegotowy. Odśwież stronę za chwilę.", status: :not_found
      end
    end
  end
end
