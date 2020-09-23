require 'nokogiri'
require 'open-uri'

require "sqlite3"

require 'active_record'

DB = SQLite3::Database.new "osf.db"

def wrap(value)
  value ||= ""
  if value.is_a? String
    value = "'" + value.gsub(/'/, "''") + "'"
  end
  value
end

def _get_item(property: nil, name: nil)
  raise "get_meta: needs property OR name" unless property.nil? ^ name.nil?
  which = property ? "property" : "name"
  value = property || name
  results = @doc.search("meta[#{which}='#{value}']").map {|x| x['content'] }
  # results = results.join(", ")
  results.first
end

def _get_metadata(e)
  begin
    source = URI.open(e.link).read
    @doc = Nokogiri::HTML(source)
    mtitle = _get_item(property: "og:title") || _get_item(name: "twitter:title")
    mdesc = _get_item(property: "og:description")  || _get_item(name: "twitter:description")
  rescue => err
    STDERR.puts "Error... #{err}"
  end
  mtitle ||= "STILL NEEDS TITLE"
  mdesc  ||= "STILL NEEDS DESCRIPTION"
  if e.title =~ /NEEDS/
    e.title = mtitle
  end
  if e.desc =~ /NEEDS/
    e.desc = mdesc
  end
end


class Entry # < ActiveRecord::Base
  attr_accessor :link, :title, :desc, :cats, :tags, :score, :timeout, :badcert
  def initialize
    @desc = ""
  end
end

class Category # < ActiveRecord::Base
  attr_accessor :name, :title, :desc, :list
  def initialize(name, title, desc)
    @name, @title, @desc = 
     name, title, desc
    @list = []
  end
end

class Tag # < ActiveRecord::Base
  attr_accessor :tag
  def initialize(tag)
    @tag = tag
  end
end


### toplevel

Links = []
Cats = {}
Tags = {}
Entries = []

list = DB.execute("select * from categories")
list.each do |row| 
  id, name, title, desc = *row
  Cats[name] = Category.new(name, title, desc)
end

###

def new_category
  name, title = _data.split(" ", 2)
  desc = _body.join("\n")
  cat = Category.new(name, title, desc)
  add_cat(name, title, desc)
  Cats[cat.name] = cat
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

def _get_scored_item(str)
  word, score = str.split("/")
  score ||= 0
# STDERR.puts "--- GOT: #{[word, score].inspect}"
  [word, score]
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

def get_id(table, field, value, *fields)
  STDERR.puts [table, field, value, *fields].inspect
  exist = DB.execute("select * from #{table} where #{field}=#{wrap value}")
  if exist.empty?
#   STDERR.puts "=== OOPS? #{table} #{field} #{value}"
    case table
      when :links
#       STDERR.puts " === ADD LINK"
        add_link(*fields)
      when :categories
#       STDERR.puts " === ADD CAT"
        add_cat(*fields)
      when :tags
        STDERR.puts " === ADD TAG"
        add_tag(*fields)
    end
    exist = DB.execute("select * from #{table} where #{field}=#{wrap value}")
  end
  return exist.first.first
end

def add_link(link, title, desc, timeout, badcert)
  sql = "insert into links values(null, #{wrap link}, #{wrap title}, #{wrap desc}, false, false);"
  STDERR.puts "\n" + sql
  DB.execute(sql)
end

def add_cat(name, title, desc)
  sql = "insert into categories values(null, #{wrap name}, #{wrap title}, #{wrap desc});"
  DB.execute(sql)
end

def add_tag(tag)
  sql = "insert into tags values(null, #{wrap tag});"
  DB.execute(sql)
end

def add_cat_score(linkid, catid, score)
# STDERR.puts "Add CAT: #{[linkid, catid, score].inspect}"
  exist = DB.execute("select * from category_scores where link_id = #{linkid} and cat_id = #{catid}")
  if exist.empty?
    DB.execute("insert into category_scores values(#{linkid}, #{catid}, #{score})")
  end
end

def add_tag_score(linkid, tagid, score)
# STDERR.puts "Add TAG: #{[linkid, tagid, score].inspect}"
  exist = DB.execute("select * from tag_scores where link_id = #{linkid} and tag_id = #{tagid}")
  if exist.empty?
    DB.execute("insert into tag_scores values(#{linkid}, #{tagid}, #{score})")
  end
end

def entry
  e = Entry.new
  Entries << e
  e.title = @_data
  e.cats = {}
  e.tags = {}
  STDERR.puts e.title
  link = cats = tags = nil
  linkid = catid = tagid = nil
  _body.each do |line|
    line.chomp!
    case line
      when /link/
        e.link = _get_data(line)
        Links << e.link
      when /desc/
        e.desc << line.split(" ", 2)[1]
        linkid = get_id(:links, :link, e.link, e.link, e.title, e.desc, e.timeout, e.badcert)
        # add_link(e.link, e.title, e.desc)
      when /cats/
        cats = _get_data!(line)
        cats.each do |cat| 
          word, score = _get_scored_item(cat)
          score = score.to_i
          e.cats[word] = score
          Cats[word].list << e
          catid = get_id(:categories, :name, word, word, e.title, e.desc)
          add_cat_score(linkid, catid, score)
        end
      when /tags/
        tags = _get_data!(line)
        tags.each do |tag| 
          word, score = _get_scored_item(tag)
          e.tags[word] = score
          Tags[tag] ||= []
          Tags[tag] << e
          tagid = get_id(:tags, :tag, word, word)
          add_tag_score(linkid, tagid, score)
        end
      when /score/
        e.score = _get_data(line).to_i
    end
  end
end

def find_dups    # Run at end of input file
  ulinks = Links.dup.uniq
  STDERR.puts "Total links: #{ulinks.size}"
  links = Links.dup
  ulinks.each do |link|
    i = links.index(link)
    links[i] = nil
  end
  dups = links.compact!
  unless dups.empty?
    STDERR.puts "\nApparent duplicates:"
    dups.each {|x| STDERR.puts "  " + x }
  end

  # Also look up some stuff
  Entries.each do |e|
    if e.title =~ /^ NEEDS/ || e.desc =~ /^ NEEDS/
      _get_metadata(e)  # Omits "STILL NEEDS"
    STDERR.puts <<~EOF
      .entry #{e.title}
      link #{e.link}
      desc #{e.desc}
      cats #{e.cats.map {|k,v| "#{k}/#{v}" }.join(" ")}
      tags #{e.tags.map {|k,v| "#{k}/#{v}" }.join(" ")}
      .end

    EOF
    end
  end
end

def category
  cat = _args[0]
  title = Cats[cat].title
  list = Cats[cat].list
  desc = Cats[cat].desc

  (STDERR.puts "#{cat} has no links"; return) if list.empty?

  list = list.sort {|a, b| b.cats[cat] <=> a.cats[cat] }

  # STDERR.puts "----- cat = #{cat}  title = #{title}  #{list.size} items"

  if title.nil?
    STDERR.puts "Unknown title for #{cat}"
  end

  _out <<~HTML
  <div class="card">
  <button class="btn btn-link card-header bg-primary text-white text-left py-2" type="button" data-toggle="collapse" data-target="##{cat}" aria-expanded="false" aria-controls="#{cat}">
    <div style="float: left">#{title}</div> <div style="float: right"> <font size=-1>#{list.size} links</font></div>
  </button>
  </div>
<div class="collapse" id="#{cat}" aria-labelledby="headingOne" data-parent="#accordionExample">
  <div class="card-body card-fixed-height pt-1">
HTML
  _out "<b>" + desc + "</b> <br><br>"
  list.each do |item|
    score = item.cats[cat]
    size = case (score / 34)
      when 0; "-1"
      when 1; "+0"
      when 2; "+1"
    end
    _out %[<p class="d-block mb-1"><font size=#{size}><a href=#{item.link}>#{item.title}</a>  #{item.desc}</font></p>]
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

def all_tags
  sizes = {}
  Tags.each_pair do |tag, array|
    font = Math.log(array.size).ceil
    sizes[font] ||= []
    sizes[font] << tag
  end
  fonts = sizes.keys.sort.reverse
  STDERR.puts "<center>"
  STDERR.puts "<table width=800><tr><td>"
  STDERR.puts "<center>"
  fonts.each do |font|
    sizes[font].each do |tag|
      STDERR.puts "<font size=+#{font}>#{tag.gsub(/_/, " ")}&nbsp;</font> "
    end
    STDERR.puts "<br>"
  end
  STDERR.puts "</center>"
  STDERR.puts "</td></tr></table>"
  STDERR.puts "</center>"
end
