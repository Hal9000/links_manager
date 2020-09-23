class CategoriesLink < ApplicationRecord
  has_many :links
  has_many :categories
end
