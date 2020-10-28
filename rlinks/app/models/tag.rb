class Tag < ApplicationRecord
  has_many :tag_scores
  has_many :links, through: :tag_scores

  def tag_score_obj(link_id)
    TagScore.where(link_id: link_id, tag_id: self.id).first
  end

  def link_score(link_id)
    tag_score_obj(link_id).score
  end
end
