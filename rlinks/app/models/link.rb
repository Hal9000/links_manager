class Link < ApplicationRecord
  has_many :category_scores, inverse_of: :link
  has_many :tag_scores, inverse_of: :link
  has_many :categories, through: :category_scores
  has_many :tags, through: :tag_scores

  accepts_nested_attributes_for :category_scores
  accepts_nested_attributes_for :tag_scores

  def tag_score(tag_id)
    TagScore.where(link_id: self.id, tag_id: tag_id).first.score
  end
  
  def category_score(category_id)
    CategoryScore.where(link_id: self.id, category_id: category_id).first.score
  end
  
end
