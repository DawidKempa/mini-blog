class PdfGenerator
  def initialize(template_path, params = {})
    @template_path = template_path
    @params = params
  end

  def generate
    @skip_pagination = true
    # Załaduj dane zależnie od template_path
    case @template_path
    when 'admin/users/index'
      @users = User.all.order(created_at: :desc)
    when 'admin/posts/index'
      @posts = Post.all.order(created_at: :desc)
    when 'admin/comments/index'
      @comments = Comment.all.order(created_at: :desc)
    when 'admin/pages/index'
      @pages = Page.all.order(:position)
    end

    html = ApplicationController.render(
      template: @template_path,
      layout: 'pdf',
      assigns: instance_variables_hash,
      formats: [:html]
    )

    processed_html = process_image_paths(html)

    Grover.new(
      processed_html,
      executable_path: ENV['GROVER_EXECUTABLE_PATH'] || '/usr/bin/google-chrome-stable',
      timeout: 120_000,
      wait_until: 'networkidle0',
      launch_args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu',
        '--remote-debugging-port=9222',
        '--single-process',
        '--headless',
        '--disable-software-rasterizer',
        '--headless=new'
      ]
    ).to_pdf
  end

  private

  def process_image_paths(html)
    doc = Nokogiri::HTML(html)
    
    doc.css('img').each do |img|
      src = img['src']
      if src.present? && !src.start_with?('data:image')
        if File.exist?(Rails.root.join('public', URI.parse(src).path))
          img_data = File.read(Rails.root.join('public', URI.parse(src).path))
          img['src'] = "data:image/#{File.extname(src).delete('.')};base64,#{Base64.strict_encode64(img_data)}"
        end
      end
    end
    doc.to_html
  end

  def instance_variables_hash
    # Przekaż do rendera wszystkie instancje zmiennych (np. @users, @posts)
    instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
    end
  end
end
