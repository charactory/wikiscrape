#!/usr/bin/ruby -w

require 'rubygems'
require 'hpricot'
require 'open-uri'

#$selection = s_entries[gets.chomp!.to_i-1].chomp!.strip!.gsub(" ", "+").gsub("(", "%28").gsub(")", "%29")
$keyword = "mulesing".gsub(" ", "+")
$keyword.gsub('(', "%28").gsub(')', '%28')
#$keyword.strip!.gsub!(" ", "+").gsub!("(", "%28").gsub!(")", "%29")
raw = Hpricot(open("http://en.wikipedia.org/wiki/Special:Search?search=#{$keyword}&fulltext=Search"))
#
#
#Chops off any content after Table of Contents

if raw.to_s.index('<table class="toc" id="toc" summary="Contents">') == nil
  wiki = raw
else
  wiki = Hpricot(raw.to_s.slice(1..raw.to_s.index('<table class="toc" id="toc" summary="Contents">')))
end

disambig = (wiki/"div.dablink")
bod = (wiki/"#bodyContent")

search = (wiki/"ul.mw-search-results/li/:not(div.mw-search-result-data)").inner_text

s_entries = []

search.each_line do |x|
  s_entries << "#{x}\r"
end

s_entries.each_index do |x|
  print "#{x+1}: #{s_entries[x]}"
end

$selection = s_entries[gets.chomp!.to_i-1].chomp!.strip!.gsub(" ", "_")
#search_selection = Hpricot(open("http://en.wikipedia.org/wiki/Special:Search?search=#{$selection}&fulltext=Search"))
search_selection = Hpricot(open("http://en.wikipedia.org/wiki/#{$selection}"))

if search_selection.to_s.index('<table class="toc" id="toc" summary="Contents">') == nil
  wiki_results = search_selection
else
  wiki_results = Hpricot(search_selection.to_s.slice(1..search_selection.to_s.index('<table class="toc" id="toc" summary="Contents">')))
end

text_body = (wiki_results/"#bodyContent/p")

no_article_found = (wiki_results/"div.noarticletext")
unless no_article_found.empty?
  puts no_article_found.inner_text
end

unless text_body.inner_text.index(/(.*)* can refer to:/)  #do not print content if disambig
  text_body.inner_text.gsub(/\[[\w\d]?\]/, "").each {|c| puts c}
  #text_body.inner_text.each {|c| puts c}
else
  #prints disambig information
  puts text_body.inner_text
  puts "\n"
  links = (bod/"li")
  links.each {|link| puts link.inner_text} unless links.empty?
end

