class Link < ApplicationRecord
  belongs_to :categories_link
  belongs_to :links_tag
  has_many :categories, through: :categories_link
  has_many :tags, through: :links_tag
end
