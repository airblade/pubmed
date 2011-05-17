#!/usr/bin/env ruby
#
# Downloads PubMed baseline files from NIH.
# N.B. use from an NIH-approved IP address.

require 'net/ftp'

if ARGV.length < 1 || ARGV.length > 2
  puts "Usage: #{__FILE__} <first> [<last>]"
  puts
  puts "Examples:"
  puts "  #{__FILE__} 638"
  puts "  #{__FILE__} 638 653"
  exit 1
end

first = ARGV.shift
last = ARGV.shift || first

Net::FTP.open 'ftp.nlm.nih.gov' do |ftp|
  ftp.login 'anonymous', 'boss@airbladesoftware.com'
  ftp.chdir 'nlmdata/.medleasebaseline/gz'
  (first..last).each do |index|
    filename = "medline11n0#{index}.xml.gz"
    md5 = "#{filename}.md5"
    print "#{filename}..."
    if File.exist? filename
      print "skip\n"
    else
      ftp.getbinaryfile filename
      ftp.getbinaryfile md5
      print "downloaded\n"
    end
  end
end
