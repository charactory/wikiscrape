#!/usr/bin/ruby -w

require 'rubygems'
require 'hpricot'
require 'open-uri'

$keyword = ARGV.join(" ").gsub(" ", "+")
ARGV.clear
$keyword.gsub('(', "%28").gsub(')', '%28')
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

#search is an array of search result names
search = (wiki/"ul.mw-search-results/li/:not(div.mw-search-result-data)").inner_text

#search_links is an array of links of search results
search_links = []

(wiki/"ul.mw-search-results"/:a).each do |ah|
  links = ah.attributes['href'].sub!('/wiki/', 'http://en.wikipedia.org/wiki/')
  search_links << links 
end

s_entries = []

search.each_line do |x|
  s_entries << "#{x}\r"
end

s_entries.each_index do |x|
  print "#{x+1}: #{s_entries[x]}"
end

puts "\nType in a entry number:"

$number = gets.chomp!.to_i-1
search_selection = Hpricot(open(search_links[$number]))

if search_selection.to_s.index('<table class="toc" id="toc" summary="Contents">') == nil
  wiki_results = search_selection
else
  wiki_results = Hpricot(search_selection.to_s.slice(1..search_selection.to_s.index('<table class="toc" id="toc" summary="Contents">')))
end

(wiki_results/"table.infobox").remove
text_body = (wiki_results/"#bodyContent")
text_body = (text_body/"p/:not(#coordinates)")

no_article_found = (wiki_results/"div.noarticletext")
unless no_article_found.empty?
  puts no_article_found.inner_text
else
  unless text_body.inner_text.index(/(.*)* can refer to:/)  #do not print content if disambig
    text_body.inner_text.gsub(/\[[\w\d]{0,3}\]/, "").each {|c| puts c}
  else
    #prints disambig information
    puts text_body.inner_text
    puts "\n"
    links = (bod/"li")
    links.each {|link| puts link.inner_text} unless links.empty?
  end
end

