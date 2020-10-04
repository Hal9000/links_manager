class CategoryScore < ApplicationRecord
  belongs_to :link
  belongs_to :category
end
