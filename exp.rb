require 'nokogiri'
require 'open-uri'

  def get_item(property: nil, name: nil)
    raise "get_meta: needs property OR name" unless property.nil? ^ name.nil?
    which = property ? "property" : "name"
    value = property || name
    results = @doc.search("meta[#{which}='#{value}']").map {|x| x['content'] }
    # results = results.join(", ")
    results.first
  end

def get_metadata(link)
  STDERR.puts "\n==== #{link}"
  begin
    source = URI.open(link).read
    @doc = Nokogiri::HTML(source)
    title = get_item(property: "og:title") || get_item(name: "twitter:title")
    STDERR.puts "  title = #{title.inspect}"
    desc = get_item(property: "og:description")  || get_item(name: "twitter:description")
    STDERR.puts "  desc  = #{desc.inspect}"
  rescue => err
    STDERR.puts "Error... #{err}"
  end
  title ||= "NEEDS TITLE"
  desc  ||= "NEEDS DESCRIPTION"
  [title, desc]
end


lines = File.readlines(ARGV.first).map(&:chomp)

lines.each do |line|
  link, cats, tags = line.split("|")
  title, desc = *get_metadata(link)
  STDERR.puts "Got: #{title.inspect}"
  STDERR.puts "     #{desc.inspect}"
  puts <<~EOF
    .entry #{title}
    link #{link}
    desc #{desc}
    cats #{cats}
    tags #{tags}
    score 80
    .end

  EOF
end
