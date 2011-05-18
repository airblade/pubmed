#!/usr/bin/env ruby
#
# Downloads PubMed baseline files from NIH.
# N.B. use from an NIH-approved IP address.
#
# http://www.nlm.nih.gov/bsd/licensee/2011_stats/baseline_med_filecount.html

require 'net/ftp'
require 'digest/md5'

if ARGV.length < 1 || ARGV.length > 2
  puts "Usage: #{__FILE__} <first> [<last>]"
  puts
  puts "Examples:"
  puts "  #{__FILE__} 638"
  puts "  #{__FILE__} 638 653"
  exit 1
end

def md5_filename(baseline_filename)
  "#{baseline_filename}.md5"
end

def got_md5?(baseline_filename)
  md5_filename = md5_filename baseline_filename
  File.exist?(md5_filename) && md5file_intact?(md5_filename)
end

def got_baseline?(filename)
  File.exist?(filename) && baseline_intact?(filename)
end

def baseline_intact?(filename)
  expected_md5 = IO.read(md5_filename(filename)).chomp.split(' = ').last
  actual_md5 = Digest::MD5.file(filename).to_s
  expected_md5 == actual_md5
end

def md5file_intact?(filename)
  File.size(filename) == 63
end

def get(filename, ftp)
  ftp.getbinaryfile filename
end


first = ARGV.shift
last = ARGV.shift || first

Net::FTP.open 'ftp.nlm.nih.gov' do |ftp|
  ftp.login 'anonymous', 'boss@airbladesoftware.com'
  ftp.chdir 'nlmdata/.medleasebaseline/gz'
  (first..last).each do |index|
    filename = "medline11n0#{index}.xml.gz"
    print "#{filename}"

    get(md5_filename(filename), ftp) unless got_md5?(filename)

    if got_baseline?(filename)
      print "...skipped\n"
    else
      get filename, ftp
      print "...downloaded\n"
    end
  end
end
