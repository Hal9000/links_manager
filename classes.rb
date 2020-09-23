
class Entry
  attr_accessor :link, :title, :desc, :cats, :tags, :score, :timeout, :badcert
  def initialize
    @desc = ""
  end
end

class Category
  attr_accessor :name, :title, :desc, :list
  def initialize(name, title, desc)
    @name, @title, @desc = 
     name, title, desc
    @list = []
  end
end

class Tag
  attr_accessor :tag
  def initialize(tag)
    @tag = tag
  end
end

