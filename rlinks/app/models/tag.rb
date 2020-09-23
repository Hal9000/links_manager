class Tag < ApplicationRecord
  has_many :links, through: :links_tags
end
