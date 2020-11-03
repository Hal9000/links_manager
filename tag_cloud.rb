@tags = File.readlines("tags.txt").map {|x| x.chomp }
@data = File.readlines("alltags.txt").map {|x| x.chomp }

# Space Crowdfund|http://spacecrowdfund.com/|finance|90

@tag_freq = {}
@tag2link = {}

@data.map! do |str|
  title, url, tag, score = str.split("|")
  score = score.to_i
  @tag_freq[tag] ||= 0
  @tag_freq[tag] += 1
  @tag2link[tag] ||= []
  @tag2link[tag] << [score, title, url]
end


@log2 = {}

@tag_freq.each_pair do |tag, imp|
  imp = imp.to_f
  log = (Math.log10(imp)/0.301).to_i 
  log = 6 if log > 6
  log = 0 if log < 0
  @log2[log] ||= []
  @log2[log] << [tag, imp]
end

sizes = @log2.keys.sort.reverse

maxen = [:dammit, 6, 7, 8, 9, 10, 11, 12]

puts "<hr>"

sizes.each.with_index do |size, i|
  tags = @log2[size]
  tags.each do |tagimp|
    tag, imp = *tagimp
    out = "tags/#{tag}.html"
    # FIXME confused now...
    @tag2link[tag] ||= []
    data = @tag2link[tag].sort.reverse
    File.open(out, "w") do |f|
      data.each do |array|  
        score, title, url = *array
STDERR.puts [score, title, url].inspect
        font = (score/33.0).floor + 1
        f.puts "<a href='#{url}' style='text-decoration:none' target='space'><font size=#{font}>#{title}</font></a><br>"
      end
   end
  end

  font = size + 1
  max = maxen[8-font]
  # STDERR.puts "max = #{max}  tags = #{list.size} font = #{font}"
  tags.each_slice(max) do |chunk|
    STDERR.puts "     chunk of #{chunk.size}..."
    chunk.each do |item|
      tag, imp = *item
      puts "<a href='tags/#{tag}.html' style='text-decoration:none' target='space'><font size=+#{font}>#{tag}&nbsp;</font></a> "
    end
    # puts "<br>"
  end
  puts "<hr>"
  # puts "<br>"
end
# puts "</center>"

