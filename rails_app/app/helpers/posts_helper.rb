module PostsHelper
  def extract_first_image(body)
    return nil unless body.present?
    
    if body.is_a?(ActionText::RichText)
      first_image_attachment = body.body.attachments.find { |a| a.image? }
      return first_image_attachment if first_image_attachment
      
      doc = Nokogiri::HTML(body.to_html)
      img_tag = doc.at_css("figure img, img")
      return img_tag["src"] if img_tag
    else
      doc = Nokogiri::HTML(body.to_s)
      img_tag = doc.at_css("img")
      img_tag["src"] if img_tag
    end
  rescue
    nil
  end
end