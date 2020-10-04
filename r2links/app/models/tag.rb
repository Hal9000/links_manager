class Tag < ApplicationRecord
  has_many :tag_scores
  has_many :links, through: :tag_scores
end
