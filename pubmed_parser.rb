#!/usr/bin/env ruby
#
# Parses PubMed baseline XML files.

require 'rubygems'
require 'nokogiri'

def log(msg)
  puts "#{Time.now}: #{msg}"
end

# XML files are ~165MB; 30,000 records.
file = ARGV[0]

# In-memory.  6m46s.
=begin
puts 'opening file'
doc = Nokogiri::XML File.open(file)
puts 'iterating'
doc.xpath('//MedlineCitation').each do |medline_citation|
  pmid = medline_citation.xpath('.//PMID')
  puts "pmid: #{pmid.text}"
end
=end

# Streaming.  52s.
=begin
class MedlineCitationSet < Nokogiri::XML::SAX::Document
  def start_element(name, attributes = [])
    @element = name
    if name == 'PMID'
      @characters = ''
    end
  end
  def end_element(name)
    if name == 'PMID'
      log @characters
      @characters = ''
    end
    @element = nil
  end
  def characters(string)
    @characters << string if @element == 'PMID'
  end
end
log "create parser"
parser = Nokogiri::XML::SAX::Parser.new(MedlineCitationSet.new)
log "start parsing"
parser.parse File.read(file)
=end

# SAX machine.  1m36s.
require 'sax-machine'

class MedLineCitation
  include SAXMachine
  element :PMID, :as => :pmid
end
class MedLineCitationSet
  include SAXMachine
  elements :MedlineCitation, :as => :citations, :class => MedLineCitation
end
log "start parsing"
citation_set = MedLineCitationSet.parse File.read(file)
log "iterate"
citation_set.citations.each do |citation|
  log citation.pmid
end
