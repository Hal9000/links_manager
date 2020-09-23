require 'active_record'

class Entry < ActiveRecord::Base
  attr_accessor :link, :title, :desc, :cats, :tags, :score, :timeout, :badcert
  def initialize
    @desc = ""
  end
end

class Category < ActiveRecord::Base
  attr_accessor :name, :title, :desc, :list
  def initialize(name, title, desc)
    @name, @title, @desc = 
     name, title, desc
    @list = []
  end
end

class Tag < ActiveRecord::Base
  attr_accessor :tag
  def initialize(tag)
    @tag = tag
  end
end

