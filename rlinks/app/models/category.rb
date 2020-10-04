class Category < ApplicationRecord
  has_many :categories_links
  has_many :links, through: :categories_links
end
