class Page < ApplicationRecord
  scope :roots, -> { where(parent_id: nil) }
  scope :published, -> { where(published: true) }
  belongs_to :user
  belongs_to :parent, class_name: 'Page', optional: true
  has_many :children, class_name: 'Page', foreign_key: 'parent_id', dependent: :nullify
  
  has_rich_text :content 
  has_many_attached :images

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  before_validation :generate_slug, on: :create

  def full_path
    parent ? "#{parent.full_path}/#{slug}" : slug
  end

  def title_with_path
  "#{'→ ' * depth} #{title} (#{full_path})"
  end

  def depth
    parent ? parent.depth + 1 : 0
  end

  def self.find_by_full_path(path)
    return nil if path.blank?
    
    slugs = path.to_s.split('/')
    current_page = Page.find_by(slug: slugs.shift)
    
    slugs.each do |slug|
      current_page = current_page&.children&.find_by(slug: slug)
      break unless current_page
    end
    
    current_page
  end

  private

  def generate_slug
    self.slug ||= title.parameterize
  end


end