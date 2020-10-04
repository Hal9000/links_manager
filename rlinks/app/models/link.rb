class Link < ApplicationRecord
  has_many :categories_link
  has_many :links_tag
  has_many :categories, through: :categories_link
  has_many :tags, through: :links_tag
end
