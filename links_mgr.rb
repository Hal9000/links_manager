
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

def bootstrap_setup
  _out <<~HTML
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <title>Space Links</title>
  <style>
    .card-fixed-height {
      max-height: 400px;
      overflow: scroll;
    }
    ::-webkit-scrollbar {
      -webkit-appearance: none;
      width: 7px;
    }
    ::-webkit-scrollbar-thumb {
      border-radius: 4px;
      background-color: rgba(0, 0, 0, .5);
      -webkit-box-shadow: 0 0 1px rgba(255, 255, 255, .5);
    }
  </style>
  </head>
  <body>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<!--
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
If you’re using our compiled JavaScript, don’t forget to include CDN versions of jQuery and Popper.js before it.

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
-->

  <main class="container my-2 py-5">
    <div class="accordion" id="accordionExample">
  HTML
end

def close_body
  _out "      </div> <!-- accordion -->"
  _out "    </div> <!-- main -->"
  _out "  </body>"
  _out "</html>"
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

def dont_finalize    # Run automatically at end of input file
  keys = CatNames.keys
  keys.each do |key|
    cat, list = key, Cats[key]
    next if list.nil?
    list = list.sort {|a, b| b.score <=> a.score }
    categ = CatNames[cat] || cat
    _out "<h2>#{categ}</h2><hr>"
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

def category
  cat = _args[0]
  title = CatNames[cat]
  list = Cats[cat] || []

  (STDERR.puts "#{cat} has no links"; return) if list.empty?

  # STDERR.puts "----- cat = #{cat}  title = #{title}  #{list.size} items"

  if title.nil?
    STDERR.puts "Unknown title for #{cat}"
  end

  _out <<~HTML
  <div class="card">
  <button class="btn btn-link card-header bg-primary text-white text-left py-3" type="button" data-toggle="collapse" data-target="##{cat}" aria-expanded="false" aria-controls="#{cat}">
    #{title}
  </button>
  </div>
</p>
<div class="collapse" id="#{cat}" aria-labelledby="headingOne" data-parent="#accordionExample">
  <div class="card-body card-fixed-height">
HTML
  # STDERR.puts "#{cat}:  #{list.size} items"
  list.each do |item|
    _out %[<a class="d-block mb-2" href=#{item.link}>#{item.title}</a>]
  end
  _out <<~HTML
  </div>
</div>
HTML
rescue => err
  STDERR.puts "Error in #{cat}"
  STDERR.puts err
  STDERR.puts err.backtrace
  exit
end

def _entry
  _body  # Just "eat" thru the .end
end
