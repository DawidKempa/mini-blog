class PdfExportJob
  include Sidekiq::Job
  sidekiq_options queue: 'pdf_generation'

  def perform(template_path, output_path)
    Rails.logger.info("Generowanie PDF: #{template_path} → #{output_path}")
    FileUtils.mkdir_p(File.dirname(output_path))

    pdf_data = PdfGenerator.new(template_path).generate

    File.open(output_path, 'wb') do |file|
      file.write(pdf_data)
    end
    Rails.logger.info("PDF zapisany: #{output_path}")
  rescue => e
    Rails.logger.error("Błąd generowania PDF: #{e.message}")
    raise e
  end
end
