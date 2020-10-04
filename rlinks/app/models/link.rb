class Link < ApplicationRecord
  has_many :category_scores
  has_many :tag_scores
  has_many :categories, through: :category_scores
  has_many :tags, through: :tag_scores
end
