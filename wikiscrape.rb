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
raw = Hpricot(open('http://en.wikipedia.org/wiki/Inverloch'))
#raw2 = Hpricot(open("/home/colin/wikipedia_test") {|x| x.to_s.slice(1..x.to_s.index('<table class="toc" id="toc" summary="Contents">'))})
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

puts disambig.inner_text if not disambig.empty?
puts "\n"

#links.each_child {|x| print x.inner_text}
#links.inner_text.split(".").each {|x| puts x}
#content = (bod/"p").inner_html.to_s
content = (bod/"p")
#content.gsub!(/<\/?[^>]*>/, "")
#print content.inner_text
#content = content.inner_text.gsub!(/\[[\w\d]*\]/, "")
#puts content
unless content.inner_text.index(/(.*)* can refer to:/)  #do not print content if disambig
content.inner_text.gsub!(/\[[\w\d]*\]/, "").each {|c| puts c}
else
  puts content.inner_text
  puts "\n"
  links = (bod/"li")
  links.each {|link| puts link.inner_text} unless links.empty?
end
#content2 = content.split(".")
#content2.each {|x| puts x}
