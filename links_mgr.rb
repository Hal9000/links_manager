
Cats = {}
Tags = {}
CatNames = {}
File.new("categories.txt").each_line do |line|
  name, title = line.chomp.split(" ", 2)
  CatNames[name] = title
end

class Entry
  attr_accessor :link, :title, :cats, :tags, :score
end

def _get_data(line)   # just a helper - get data
  data = line.split(" ", 2)[1]
  data ||= ""
  data
end

def _get_data!(line)  # helper - get multiple items
  data = _get_data(line)
  data = data.split
  data
end

def entry
  e = Entry.new
  e.title = @_data
  link = cats = tags = nil
  _body.each do |line|
    line.chomp!
    case line
      when /link/
        e.link = _get_data(line)
      when /cats/
        e.cats = _get_data!(line)
        e.cats.each do |cat| 
          Cats[cat] ||= []
          Cats[cat] << e
        end
      when /tags/
        e.tags = _get_data!(line)
        e.tags.each do |cat| 
          Tags[cat] ||= []
          Tags[cat] << e
        end
      when /score/
        e.score = _get_data(line).to_i
    end
  end
end

def finalize    # Run automatically at end of input file
  keys = CatNames.keys
  keys.each do |key|
    cat, list = key, Cats[key]
    next if list.nil?
    list = list.sort {|a, b| b.score <=> a.score }
    category = CatNames[cat] || cat
    _out "<h2>#{category}</h2><hr>"
    list.each do |e|
      _out "<a href='#{e.link}' style='text-decoration: none'>#{e.title}</a><br>"
    end
  end

  _out "<br><br><h2>Tags</h2>"

  str = ""
  keys = Tags.keys - %w[BADCERT INACTIVE TIMEOUT]
  keys.sort!
  keys.each do |key|
    tag, list = key, Tags[key]
    list = list.sort {|a, b| a.title <=> b.title }
    str = "<b><font size=+1>##{tag}</font></b>&nbsp;&nbsp; "
    list.each do |e|
      str << "<a href='#{e.link}' style='text-decoration: none'>#{e.title}</a>&nbsp;&nbsp;"
    end
    _out str
  end
  
end

def _entry
  _body  # Just "eat" thru the .end
end
