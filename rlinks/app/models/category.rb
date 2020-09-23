class Category < ApplicationRecord
  has_many :links, through: :categories_links
end
