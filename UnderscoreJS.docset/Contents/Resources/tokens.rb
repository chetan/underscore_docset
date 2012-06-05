#!/usr/bin/env ruby

# tokens.rb - generates token list from underscore documentation
# Chetan Sarva <csarva@pixelcop.net>
#
# usage: tokens.rb
#
# will output Tokens.xml in the current directory

xml = File.open("Tokens.xml", "w")
html = File.open("Documents/html/toc.html").read()

# grab categories
cats = []
html.scan(%r{<a class="toc_title" href="#(.*?)">}).each do |c|
  cats << c.first
end

# grab sections
links = html.scan(%r{<a class="toc_title" href="#(.*?)">|<a href="#(.*?)">(.*?)</a>})
sections = {}
sec = nil
links.each do |l|
  if not l.first.nil? then
    sec = l.first
    next
  end
  sections[sec] ||= []
  sections[sec] << l.slice(1,2)
end


# dump xml
xml.puts <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<Tokens version="1.0">
<File path=\"html/index.html\">
EOF

xml.puts

# cats
cats.each_with_index do |c, i|
  if i == 0 then
    xml.puts "<Token><TokenIdentifier>//apple_ref/cpp/cat/01 Underscore.js</TokenIdentifier><Anchor>logo</Anchor></Token>"
  elsif i == 1 then
    xml.puts "<Token><TokenIdentifier>//apple_ref/cpp/cat/02 Introduction</TokenIdentifier><Anchor>introduction</Anchor></Token>"
  else
    xml.puts "<Token><TokenIdentifier>//apple_ref/cpp/cat/#{(i+1).to_s.rjust(2, '0')} #{c.capitalize}</TokenIdentifier><Anchor>#{c}</Anchor></Token>"
  end
end

xml.puts

# sections
sections.each do |sec, methods|

  toks = []
  methods.each do |m|
    name = m.last.gsub(%r{constructor / }, '')
    tok = "//apple_ref/cpp/instm/#{sec}.#{name}"
    toks << tok
    anchor = m.first
    xml.puts "<Token><TokenIdentifier>#{tok}</TokenIdentifier><Anchor>#{anchor}</Anchor></Token>"
  end

  xml.puts "<Token>"
  xml.puts "<TokenIdentifier>//apple_ref/cpp/cl/#{sec.capitalize}</TokenIdentifier><Anchor>#{sec}</Anchor>"
  xml.puts "<RelatedTokens>"

  toks.each do |t|
    xml.puts "<TokenIdentifier>#{t}</TokenIdentifier>"
  end

  xml.puts "</RelatedTokens>"
  xml.puts "</Token>"
end

xml.puts
xml.puts "</File>\n</Tokens>"
