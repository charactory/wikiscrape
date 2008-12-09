#!/usr/bin/ruby -w

require 'rubygems'
require 'hpricot'
require 'open-uri'

#raw = Hpricot(open("/home/colin/Mulesing"))
#raw = Hpricot(open("/home/colin/wikipedia_test"))
#raw = Hpricot(open("http://en.wikipedia.org/wiki/Perth,_Western_Australia"))
#raw = Hpricot(open("http://en.wikipedia.org/wiki/OGRE"))
#raw = Hpricot(open('http://en.wikipedia.org/wiki/Swan_River_(Western_Australia)'))
#raw = Hpricot(open('http://en.wikipedia.org/wiki/Inverloch_(webcomic)'))
#raw = Hpricot(open('/home/colin/Paris'))
#raw = Hpricot(open('http://en.wikipedia.org/wiki/Inverloch'))
raw = Hpricot(open('http://en.wikipedia.org/wiki/asjiajs'))
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

search = (wiki/"ul.mv-search-results")

no_article_found = (wiki/"div.noarticletext")
unless no_article_found.empty?
puts no_article_found.inner_text
end

puts disambig.inner_text if not disambig.empty?
puts "\n"

content = (bod/"p")
#
unless content.inner_text.index(/(.*)* can refer to:/)  #do not print content if disambig
content.inner_text.gsub!(/\[[\w\d]*\]/, "").each {|c| puts c}
else
  #prints disambig information
  puts content.inner_text
  puts "\n"
  links = (bod/"li")
  links.each {|link| puts link.inner_text} unless links.empty?
end
