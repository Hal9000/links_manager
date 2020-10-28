class Category < ApplicationRecord
  has_many :category_scores
  has_many :links, through: :category_scores

  def category_score_obj(link_id)
    CategoryScore.where(link_id: link_id, category_id: self.id).first
  end

  def link_score(link_id)
    category_score_obj(link_id).score
  end
end
