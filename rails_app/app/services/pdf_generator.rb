class PdfGenerator
  def initialize(url)
    @url = url
  end

  def generate
    Grover.new(
      @url,
      executable_path: ENV['GROVER_EXECUTABLE_PATH'] || '/usr/bin/google-chrome-stable',
      timeout: 120_000,
      wait_until: 'networkidle0',
      launch_args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu',
        '--headless=new'
      ],
      print_background: true
    ).to_pdf
  end
end
