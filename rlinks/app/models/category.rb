class Category < ApplicationRecord
  has_many :category_scores
  has_many :links, through: :category_scores
end
