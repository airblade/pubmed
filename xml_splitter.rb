#!/usr/bin/env ruby
#
# Splits up Pubmed baseline XML files into smaller chunks.
# Each baseline file contains 30,000 citations; each chunk
# contains 3,000 citations.

CITATIONS_PER_CHUNK = 3000

HEADER = <<END
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE MedlineCitationSet PUBLIC "-//NLM//DTD Medline Citation, 1st January, 2011//EN"
                                    "http://www.nlm.nih.gov/databases/dtd/nlmmedlinecitationset_110101.dtd">
END
SET_BEGIN    = '<MedlineCitationSet>'
SET_END      = '</MedlineCitationSet>'
CITATION_END = '</MedlineCitation>'

@baseline      = ARGV[0]
@set_has_begun = false
@citations     = 0
@lines         = []

def write_mini_set(index)
  subfile = @baseline.sub '.xml', "-#{index}.xml"
  open(subfile, 'w') do |f|
    f << HEADER
    f << SET_BEGIN << "\n"
    f << @lines
    f << SET_END
  end
  puts "written #{subfile} (citations = #{@citations})"
end

# Process one line at a time to keep memory use down.
open(@baseline).each do |line|
  unless @set_has_begun
    @set_has_begun = true if line.chomp == SET_BEGIN
    next
  end

  if line.chomp == SET_END
    write_mini_set((@citations / CITATIONS_PER_CHUNK) + 1) if @lines.length > 0
    break
  end

  @lines << line

  if line.chomp == CITATION_END
    @citations += 1
    if (@citations % CITATIONS_PER_CHUNK == 0)
      write_mini_set(@citations / CITATIONS_PER_CHUNK)
      @lines = []
    end
  end
end
