#!/usr/bin/env ruby
#
# Loads Pubmed baseline gzipped XML files into database.
#
# For each .xml.gz in current directory:
#   decompress
#   split
#   for each split
#     parse
#   remove splits
#   compress xml

def run(cmd)
  print "-> #{cmd}..."
  system cmd
  print "ok\n"
end

Dir['*.xml.gz'].sort.each do |gzip_file|
  puts ('-'*78), gzip_file, ('-'*78)

  run "gzip -d #{gzip_file}"

  baseline = gzip_file.sub '.gz', ''
  run "./xml_splitter.rb #{baseline}"

  Dir["#{baseline.sub '.xml', '-*.xml'}"].sort.each do |small_xml|
    run "./pubmed_parser.rb #{small_xml}"
    run "rm #{small_xml}"
  end

  run "gzip #{baseline}"
end
