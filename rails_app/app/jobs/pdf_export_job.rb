class PdfExportJob
  include Sidekiq::Job
  sidekiq_options queue: 'pdf_generation'

  def perform(url, output_path)
    Rails.logger.info("Generowanie PDF z URL: #{url} → #{output_path}")
    FileUtils.mkdir_p(File.dirname(output_path))

    pdf_data = PdfGenerator.new(url).generate

    File.binwrite(output_path, pdf_data)
    Rails.logger.info("PDF zapisany: #{output_path}")
  rescue => e
    Rails.logger.error("Błąd generowania PDF: #{e.message}")
    raise e
  end
end
