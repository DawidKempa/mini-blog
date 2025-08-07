module Admin
  class PdfController < Admin::BaseController
    def export
      template_path = params[:template_path]
      filename = "#{template_path.split('/').last}-#{Time.current.to_i}.pdf"
      output_path = Rails.root.join("tmp/pdfs", filename)

      PdfExportJob.perform_async(template_path, output_path.to_s)

      # Zamiast do admin_root_path → przekieruj do akcji download z opóźnieniem
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
